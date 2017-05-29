import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}

extension Array where Element == JSONDictionary {
	func fill<T: JSONDecodable>() -> [T] {
		return flatMap { T(dictionary: $0) }
	}
}
