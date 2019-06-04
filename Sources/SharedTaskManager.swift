import Foundation

open class SharedTaskManager<K: Hashable, T> {
    public var createTask: ((K, @escaping (T) -> Void) -> Any)!
    var completionGroups: [K: (Any, [UUID: (T) -> Void])] = [:]
    let queue: DispatchQueue
    public init(queue: DispatchQueue = .main) {
        self.queue = queue
    }
}

public extension SharedTaskManager {
    func sharedTask(_ key: K, _ completion: @escaping (T) -> Void) -> DeinitBlock {
        let uuid = queue.syncIfNotMain {
            addCompletion(key, completion)
        }
        return DeinitBlock { [weak self] in
            self?.queue.syncIfNotMain {
                self?.removeCompletion(key, uuid)
            }
        }
    }
}

// MARK: - internal

extension SharedTaskManager {
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

    func addCompletion(_ key: K, _ completion: @escaping (T) -> Void) -> UUID {
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
        queue.syncIfNotMain {
            completionGroups[key]?.1.forEach { _, value in
                value(result)
            }
            completionGroups.removeValue(forKey: key)
        }
    }
}
