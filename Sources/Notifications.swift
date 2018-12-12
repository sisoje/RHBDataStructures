import Foundation

public extension NotificationCenter {
    func addSmartObserver(name: NSNotification.Name? = nil, object: Any? = nil, queue: OperationQueue? = nil, _ block: @escaping (Notification) -> Void) -> DeinitBlock {
        let observer = addObserver(forName: name, object: object, queue: queue, using: block)
        return DeinitBlock { [weak self] in
            self?.removeObserver(observer)
        }
    }
}

public extension Notification.Name {
    func defaultCenterObserver(object: Any? = nil, queue: OperationQueue? = nil, _ block: @escaping (Notification) -> Void) -> DeinitBlock {
        return NotificationCenter.default.addSmartObserver(name: self, object: object, queue: queue, block)
    }
}
