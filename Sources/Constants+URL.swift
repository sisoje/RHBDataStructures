import Foundation

public extension URL {
    static let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let temporary = FileManager.default.temporaryDirectory
    static let applicationGroup = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: .securityApplicationGroupIdentifier)!
}
