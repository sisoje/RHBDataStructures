import Foundation

public class SmartObserver {
    var deinitBlock: DeinitBlock?
    init(_ block: @escaping () -> Void) {
        self.deinitBlock = DeinitBlock(onDeinit: block)
    }
    public func remove() {
        deinitBlock = nil
    }
}

public extension NotificationCenter {
    func addSmartObserver(name: NSNotification.Name? = nil, object: Any? = nil, queue: OperationQueue? = nil, _ block: @escaping (Notification) -> Void) -> SmartObserver {
        let observer = addObserver(forName: name, object: object, queue: queue, using: block)
        return SmartObserver { [weak self] in
            self?.removeObserver(observer)
        }
    }
}
