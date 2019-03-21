import Foundation

extension DispatchQueue {
    func mainSync<T>(_ block: ()->T) -> T {
        guard self == .main, Thread.isMainThread else {
            return sync(execute: block)
        }
        return block()
    }
}

open class CompletionManager<K: Hashable, T> {
    public var createTask: ((K, @escaping (T)->Void) -> Any)!
    var completionGroups: [K: (Any, [UUID: (T) -> Void])] = [:]
    let queue: DispatchQueue
    public init(queue: DispatchQueue = .main) {
        self.queue = queue
    }
}

private extension CompletionManager {
    func removeCompletion(_ key: K, _ uuid: UUID) {
        guard let pair = completionGroups[key] else {
            return
        }
        var dic = pair.1
        dic.removeValue(forKey: uuid)
        if dic.isEmpty {
            completionGroups.removeValue(forKey: key)
        } else {
            completionGroups[key] = (pair.0, dic)
        }
    }

    func addCompletion(_ key: K, _ completion: @escaping (T)->Void) -> UUID {
        let pair = completionGroups[key]
        let sharedTask = pair?.0 ?? createTask(key) { [weak self] result in
            self?.finish(key, result)
        }
        var dic = pair?.1 ?? [:]
        let uuid = UUID()
        dic[uuid] = completion
        completionGroups[key] = (sharedTask, dic)
        return uuid
    }

    func finish(_ key: K, _ result: T) {
        queue.mainSync {
            completionGroups[key]?.1.forEach { _, value in
                value(result)
            }
            completionGroups.removeValue(forKey: key)
        }
    }
}

public extension CompletionManager {
    func sharedTask(_ key: K, _ completion: @escaping (T) -> Void) -> DeinitBlock {
        let uuid = queue.mainSync {
            return addCompletion(key, completion)
        }
        return DeinitBlock { [weak self] in
            self?.queue.mainSync {
                self?.removeCompletion(key, uuid)
            }
        }
    }
}
