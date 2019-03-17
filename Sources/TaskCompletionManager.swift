import Foundation

public typealias DataTaskCompletionBlock = (Data?, URLResponse?, Error?) -> Void
public typealias DataTaskData = OptionalPair<Data, URLResponse>
public typealias DataTaskResult = Result<DataTaskData, Error>

public extension DataTaskResult {
    init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        self = Result(OptionalPair(data, response), error)
    }
    static func dataTaskCompletionBlock(_ block: @escaping (DataTaskResult)->Void) -> DataTaskCompletionBlock {
        return { data, response, error in
            block(DataTaskResult(data, response, error))
        }
    }
}

open class TaskCompletionManager<K: Hashable, T> {
    public typealias RESULT = Result<T, Error>
    let completionManager = CompletionManager<K, RESULT>()
    public init(dataMapper: @escaping (DataTaskData) -> RESULT, taskRunner: @escaping (K, @escaping DataTaskCompletionBlock) -> DeinitBlock) {
        self.completionManager.taskRunnerCreator = { [weak self] key in
            let completionHandler = DataTaskResult.dataTaskCompletionBlock { dataTaskResult in
                guard self != nil else {
                    return
                }
                let result = dataTaskResult.flatMap(dataMapper)
                DispatchQueue.main.async {
                    self?.completionManager.finish(key, result)
                }
            }
            return taskRunner(key, completionHandler)
        }
    }
}

public extension TaskCompletionManager {
    func managedTask(_ key: K, _ block: @escaping (RESULT) -> Void) -> DeinitBlock {
        return completionManager.manageCompletion(key, block)
    }
}
