import Foundation

public class CacheByURL<T: AnyObject>: Cache<URL, T> {
    let taskCompletionManager: TaskCompletionManager<URL, T>
    public init(taskCompletionManager: TaskCompletionManager<URL, T>) {
        self.taskCompletionManager = taskCompletionManager
    }
}

public extension CacheByURL {
    func cachedObject(url: URL, _ block: @escaping (Result<T, Error>) -> Void) -> DeinitBlock? {
        if let object = self[url] {
            block(.success(object))
            return nil
        }

        return taskCompletionManager.managedTask(url) { [weak self] result in
            self.map { cache in
                cache[url] = try? result.get()
                block(result)
            }
        }
    }
}
