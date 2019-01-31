import Foundation

public extension URLSessionDataTask {
    var canceller: DeinitBlock {
        return DeinitBlock { [weak self] in
            self?.cancel()
        }
    }
}
