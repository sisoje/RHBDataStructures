import Foundation

public extension Optional {
    func forceUnwrap() throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationInfo(self)
        }
        return result
    }

    func forceCast<T: Any>(as type: T.Type) throws -> T {
        guard let result = self as? T else {
            throw CodeLocationInfo((self, type))
        }
        return result
    }
}

public extension Result where Failure == Error {
    static func makeResult(_ value: Success?, _ error: Error?) -> Result<Success, Error> {
        Result {
            try error.map {
                throw $0
            }
            return try value.forceUnwrap()
        }
    }
}
