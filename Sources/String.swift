import Foundation

public extension String {
    static func makeFromKeyPath<T: NSObjectProtocol, V>(_ keyPath: KeyPath<T, V>) -> String {
        return NSExpression(forKeyPath: keyPath).keyPath
    }

    var asUrl: URL? {
        return URL(string: self)
    }
}
