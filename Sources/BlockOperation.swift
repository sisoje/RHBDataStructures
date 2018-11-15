import Foundation

public extension BlockOperation {
    convenience init(selfBlock: @escaping (BlockOperation) -> Void) {
        self.init()
        addExecutionBlock { [unowned self] in
            selfBlock(self)
        }
    }
}
