import Foundation

public extension URLSessionDataTask {
    func taskRunner() -> DeinitBlock {
        resume()
        return DeinitBlock { [weak self] in
            self?.cancel()
        }
    }
}
