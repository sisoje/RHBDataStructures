import Foundation

public extension String {
    internal static var applicationGroupIdentifier: String!

    static func initApplicationGroupIdentifier(_ identifier: String) {
        .applicationGroupIdentifier = identifier
    }
}

public extension URL {
    static let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let temporary = FileManager.default.temporaryDirectory
    static let applicationGroup = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: .applicationGroupIdentifier)!
}

public extension UserDefaults {
    static let applicationGroup = UserDefaults(suiteName: .applicationGroupIdentifier)!
}

public extension URLSession {
    static let returnCacheDataElseLoadSession = URLSession(
        configuration: .default ~ {
            $0.requestCachePolicy = .returnCacheDataElseLoad
        }
    )
}
