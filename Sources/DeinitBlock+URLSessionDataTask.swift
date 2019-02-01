import Foundation

public extension URLSessionDataTask {
    var canceller: DeinitBlock {
        return DeinitBlock { [weak self] in
            self?.cancel()
        }
    }
    var runner: DeinitBlock {
        resume()
        return canceller
    }
}
