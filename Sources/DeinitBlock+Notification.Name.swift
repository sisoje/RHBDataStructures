import Foundation

public extension Notification.Name {
    func addSmartObserver(center: NotificationCenter = .default, object: Any? = nil, queue: OperationQueue? = nil, _ block: @escaping (Notification) -> Void) -> DeinitBlock {
        return center.addSmartObserver(name: self, object: object, queue: queue, block)
    }
}
