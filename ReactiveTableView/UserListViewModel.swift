import Foundation
import RxSwift

class UserListViewModel {
	
	var result: Observable<ResultStatus<User>> {
		return usersVariable.asObservable()
	}
	
	var error: Observable<Error> {
		return errorSubject.asObservable()
	}
	
	private let bag = DisposeBag()
	private let userService = UserService()
	private let usersVariable: Variable<ResultStatus<User>> = Variable(UserListViewModel.fakeUsers())
	private let errorSubject = PublishSubject<Error>()

	func loadUsers() {
		userService.getUsers()
			.subscribe(onNext: { [unowned self] usersTransaction in
				switch usersTransaction {
				case .success(let usersDictionary):
					let users: [User] = usersDictionary.fill()
					self.usersVariable.value = ResultStatus(elements: users, loading: false)
				case .error(let error):
					self.errorSubject.onNext(error)
				}
			})
			.addDisposableTo(bag)
	}
	
	func getViewModelForCell(at indexPath: IndexPath) -> UserCellViewModel {
		return UserCellViewModel(user: usersVariable.value.elements[indexPath.row])
	}
	
	static func fakeUsers() -> ResultStatus<User> {
		let users = (1...3).map { _ in User() }
		return ResultStatus(elements: users, loading: true)
	}
}
