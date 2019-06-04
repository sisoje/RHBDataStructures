import Foundation

open class CachedTaskManager<K: Hashable, T: AnyObject> {
    let taskManager: SharedTaskManager<K, Result<T, Error>>
    let cache: Cache<K, T>

    public init(taskManager: SharedTaskManager<K, Result<T, Error>>, cache: Cache<K, T> = Cache()) {
        self.taskManager = taskManager
        self.cache = cache
    }
}

public extension CachedTaskManager {
    func cached(_ key: K, _ block: @escaping (Result<T, Error>) -> Void) -> DeinitBlock? {
        if let object = cache[key] {
            block(.success(object))
            return nil
        }

        return taskManager.sharedTask(key) { [weak self] result in
            self.map {
                $0.cache[key] = try? result.get()
                block(result)
            }
        }
    }
}
