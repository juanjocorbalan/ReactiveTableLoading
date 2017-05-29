import Foundation

public enum Transaction<T> {
	case success(T)
	case error(Error)
}
