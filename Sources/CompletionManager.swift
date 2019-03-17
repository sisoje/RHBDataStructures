import Foundation

open class CompletionManager<K: Hashable, T> {
    public var taskRunnerCreator: ((K) -> DeinitBlock)!
    var completionGroups: [K: (DeinitBlock, [UUID: (T) -> Void])] = [:]
}

extension CompletionManager {
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
        let deiniter = pair?.0 ?? taskRunnerCreator(key)
        var dic = pair?.1 ?? [:]
        let uuid = UUID()
        dic[uuid] = completion
        completionGroups[key] = (deiniter, dic)
        return uuid
    }
}

public extension CompletionManager {
    func finish(_ key: K, _ result: T) {
        completionGroups[key]?.1.forEach {
            $1(result)
        }
        completionGroups.removeValue(forKey: key)
    }

    func manageCompletion(_ key: K, _ completion: @escaping (T) -> Void) -> DeinitBlock {
        let uuid = addCompletion(key, completion)
        return DeinitBlock { [weak self] in
            self?.removeCompletion(key, uuid)
        }
    }
}
