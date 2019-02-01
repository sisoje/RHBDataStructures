import Foundation

extension String {
    static var applicationGroupIdentifier: String!
}

public extension String {
    static func initApplicationGroupIdentifier(_ identifier: String) {
        .applicationGroupIdentifier = identifier
    }
}
