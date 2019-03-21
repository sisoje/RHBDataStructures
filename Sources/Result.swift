import Foundation

public extension Result where Failure == Error {
    init(_ value: Success?, _ error: Error?) {
        self = .createResult(value, error)
    }

    func railMap<NewSuccess>(_ transform: (Success) -> NewSuccess?) -> Result<NewSuccess, Error> {
        return flatMap {
            transform($0).map { .success($0) } ?? .failureWithValue($0)
        }
    }

    func railMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        return flatMap {
            do {
                return .success(try transform($0))
            } catch {
                return .failureWithValueAndError($0, error)
            }
        }
    }
}

public extension Result {
    static func failureEmpty<T>(domain: String = #function) -> Result<T, Error> {
        return .failure(NSError(domain: domain, code: 0, userInfo: nil))
    }

    static func failureWithValueAndError<T, V>(_ value: V, _ error: Error, domain: String = #function) -> Result<T, Error> {
        return .failure(NSError(
            domain: domain,
            code: 0,
            userInfo: [
                "value": value,
                "error": error
            ])
        )
    }

    static func failureWithValue<T, V>(_ value: V, domain: String = #function) -> Result<T, Error> {
        return .failure(NSError(
            domain: domain,
            code: 0,
            userInfo: [
                "value": value
            ])
        )
    }

    static func createResult<T>(_ value: T?, _ error: Error?) -> Result<T, Error> {
        if let value = value, let error = error {
            return .failureWithValueAndError(value, error)
        }
        if let value = value {
            return .success(value)
        }
        if let error = error {
            return .failure(error)
        }
        return .failureEmpty()
    }
}
