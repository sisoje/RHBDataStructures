import Foundation

public extension Notification.Name {
    func defaultCenterObserver(object: Any? = nil, queue: OperationQueue? = nil, _ block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: block)
    }
}
