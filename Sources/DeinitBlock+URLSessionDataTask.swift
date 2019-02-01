import Foundation

public extension URLSessionDataTask {
    var cancellation: DeinitBlock {
        return DeinitBlock { [weak self] in
            self?.cancel()
        }
    }
    var runner: DeinitBlock {
        resume()
        return cancellation
    }
}
