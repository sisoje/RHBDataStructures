import Foundation

public extension OperationQueue {
    @discardableResult
    func addBlockOperation(_ block: @escaping () -> Void) -> BlockOperation {
        let operation = BlockOperation(block: block)
        addOperation(operation)
        return operation
    }

    func addOperationInsideAutoreleasePool(_ block: @escaping () -> Void) {
        autoreleasepool {
            addOperation(block)
        }
    }
}
