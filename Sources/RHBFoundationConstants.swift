import Foundation

public enum RHBFoundationConstants {}

public extension RHBFoundationConstants {
    static let isDebug: Bool = {
        var b = false
        assert({ b = true }() == ())
        return b
    }()

    static let isSimulator = TARGET_OS_SIMULATOR != 0

    static let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    static let temporaryDirectoryUrl = FileManager.default.temporaryDirectory
}
