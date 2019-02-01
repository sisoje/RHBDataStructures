import Foundation

public extension UserDefaults {
    static let applicationGroup = UserDefaults(suiteName: .applicationGroupIdentifier)!
}
