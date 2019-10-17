import Foundation

public extension String {
    static func makeFromKeyPath<T: NSObjectProtocol, V>(_ keyPath: KeyPath<T, V>) -> String {
        NSExpression(forKeyPath: keyPath).keyPath
    }

    var asUrl: URL? {
        URL(string: self)
    }
}
