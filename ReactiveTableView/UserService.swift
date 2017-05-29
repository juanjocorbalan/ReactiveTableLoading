import Foundation
import RxSwift
import Alamofire

enum NetworkError: Error {
	case unknown
	case invalidResponse
	case networkException
}

class UserService {
	
	enum UserAPIRouter: URLRequestConvertible {
		
		static let baseURLString: String = "https://api.randomuser.me/"
		
		case getUsers()
		
		var httpMethod: Alamofire.HTTPMethod {
			switch self {
			case .getUsers():
				return .get
			}
		}
		
		var path: String {
			switch self {
			case .getUsers():
				return ""
			}
		}
		
		var params: [String: AnyObject]? {
			switch self {
			case .getUsers():
				let params: [String:AnyObject] = ["results": 10 as AnyObject]
				return params
			}
		}
		
		public func asURLRequest() throws -> URLRequest {
			var url = URL(string: UserAPIRouter.baseURLString)!
			url.appendPathComponent(path)
			
			var mutableURLRequest = URLRequest(url: url)
			mutableURLRequest.httpMethod = httpMethod.rawValue
			mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
			
			switch self {
			case .getUsers(_):
				fallthrough
			default:
				do {
					let encoding =  URLEncoding(destination: URLEncoding.Destination.queryString)
					return try encoding.encode(mutableURLRequest, with: params)
				} catch {
					return mutableURLRequest
				}
			}
		}
	}
	
	func getUsers() -> Observable<Transaction<[JSONDictionary]>> {
		
		return Observable.create { observer in
			
			let request = Alamofire.request(UserAPIRouter.getUsers()).validate().responseJSON { response in
				
				switch response.result {
				case .success:
					if let value = response.result.value as? JSONDictionary, let usersJSON = value["results"] as? [JSONDictionary] {
						observer.onNext(usersJSON)
						observer.onCompleted()
					} else {
						observer.onError(NetworkError.invalidResponse)
					}
				case .failure(let error):
					observer.onError(error)
				}
			}
			
			return Disposables.create(with: {
				request.cancel()
			})
			}
			.flatMap { data in
				return Observable.just(Transaction.success(data))
			}
			.catchError { error in
				return Observable.just(Transaction.error(NetworkError.networkException))
			}
	}
}
