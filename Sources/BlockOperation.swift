import Foundation

public extension BlockOperation {
    convenience init(inside: @escaping (BlockOperation) -> Void) {
        self.init()
        addExecutionBlock { [unowned self] in
            inside(self)
        }
    }
}
