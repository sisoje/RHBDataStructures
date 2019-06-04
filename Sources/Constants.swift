import Foundation

public extension String {
    private(set) static var applicationGroupIdentifier: String!
    static func initOnce(applicationGroupIdentifier: String) {
        self.applicationGroupIdentifier = applicationGroupIdentifier
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
