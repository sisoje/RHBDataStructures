import Foundation

public protocol BlockWrapperProtocol: class {
    func wrapBlock<T>(_ originalBlock: @escaping (T)->Void) -> (T) -> Void
}

public extension BlockWrapperProtocol {
    func wrapBlock<T>(_ originalBlock: @escaping (T)->Void) -> (T) -> Void {
        return { [weak self] t in
            self.map {_ in
                originalBlock(t)
            }
        }
    }
}
