import Foundation

public enum ErrorWithValue<T>: Error {
    case value(T)
    case valueAnderror(T, Error)
    case empty
}

public extension Result where Failure == Error {
    init(_ value: Success?, _ error: Error?) {
        self = .createResult(value, error)
    }

    func mapOptional<NewSuccess>(_ transform: (Success) -> NewSuccess?) -> Result<NewSuccess, Error> {
        return flatMap {
            transform($0).map { .success($0) } ?? .failure(ErrorWithValue.value($0))
        }
    }

    func mapThrowable<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        return flatMap {
            do {
                return .success(try transform($0))
            } catch {
                return .failure(ErrorWithValue.valueAnderror($0, error))
            }
        }
    }

    static func createResult(_ value: Success?, _ error: Error?) -> Result<Success, Error> {
        if let value = value, let error = error {
            return .failure(ErrorWithValue.valueAnderror(value, error))
        }
        if let value = value {
            return .success(value)
        }
        if let error = error {
            return .failure(error)
        }
        return .failure(ErrorWithValue<Success>.empty)
    }
}
