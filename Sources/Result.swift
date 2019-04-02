import Foundation

public extension Result where Failure == Error {
    enum ErrorWithInfo: Error {
        case empty
        case value(Any)
        case valueAnderror(Any, Error)
    }

    init(_ value: Success?, _ error: Error?) {
        self = .createResult(value, error)
    }

    func mapOptional<NewSuccess>(_ transform: (Success) -> NewSuccess?) -> Result<NewSuccess, Error> {
        return flatMap {
            transform($0).map { .success($0) } ?? .failureWithInfo(.value($0))
        }
    }

    func mapThrowable<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        return flatMap {
            do {
                return .success(try transform($0))
            } catch {
                return .failureWithInfo(.valueAnderror($0, error))
            }
        }
    }

    static func createResult(_ value: Success?, _ error: Error?) -> Result<Success, Error> {
        if let value = value, let error = error {
            return .failureWithInfo(.valueAnderror(value, error))
        }
        if let value = value {
            return .success(value)
        }
        if let error = error {
            return .failure(error)
        }
        return .failureWithInfo(.empty)
    }

    static func failureWithInfo(_ error: ErrorWithInfo) -> Result<Success, Error> {
        return .failure(error)
    }
}
