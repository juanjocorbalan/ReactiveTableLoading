import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class UserListViewController: UIViewController {
	
	private let bag = DisposeBag()
	private lazy var loadingVC = LoadingViewController(nibName: nil, bundle: nil)
	var loadintType: LoadingIndicatorType!
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.tableFooterView = UIView()
		}
	}
	
	var viewModel: UserListViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Users"
		setupRx()
		
		viewModel.loadUsers()
	}
	
	private func setupRx() {
		
		tableView.rx.setDelegate(self).addDisposableTo(bag)
		
		viewModel.result
			.do(onNext: { [weak self] result in
				guard let strongSelf = self else  { return }
				switch result.loading {
				case true:
					strongSelf.loadintType == .fakePlaceholder ? Shimmer.addShimmerTo(strongSelf.tableView) : strongSelf.startAnimating()
				case false:
					strongSelf.loadintType == .fakePlaceholder ? Shimmer.removeShimmerFrom(strongSelf.tableView) : strongSelf.stopAnimating()
				}
			})
			.map { $0.elements }
			.bind(to: tableView.rx.items) { [weak self] tableView, index, cell in
				let indexPath = IndexPath(item: index, section: 0)
				let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
				guard let strongSelf = self else  { return defaultCell }
				
				guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellId,
				                                               for: indexPath) as? UserTableViewCell else { return defaultCell }
				
				cell.configure(with: strongSelf.viewModel.getViewModelForCell(at: indexPath))
				
				return cell
			}
			.addDisposableTo(self.bag)
	}
	
	// MARK: - Utils
	
	private func startAnimating() {
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf = self else  { return }
			strongSelf.loadingVC.view.translatesAutoresizingMaskIntoConstraints = false
			strongSelf.view.addSubview(strongSelf.loadingVC.view)
			strongSelf.loadingVC.setupConstraints()
			strongSelf.addChildViewController(strongSelf.loadingVC)
		}
	}
	
	private func stopAnimating() {
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf = self else  { return }
			strongSelf.loadingVC.view.removeFromSuperview()
			strongSelf.loadingVC.removeFromParentViewController()
		}
	}
}

extension UserListViewController: UITableViewDelegate { }

