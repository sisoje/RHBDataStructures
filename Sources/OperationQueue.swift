import Foundation

public extension OperationQueue {
    @discardableResult
    func addBlockOperation(_ block: @escaping (BlockOperation) -> Void) -> BlockOperation {
        let operation = BlockOperation(selfBlock: block)
        addOperation(operation)
        return operation
    }
}
