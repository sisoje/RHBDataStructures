import Foundation

public struct ErrorWithInfo<INFO>: Error {
    public let error: Error
    public let info: INFO
    public init(_ error: Error, _ info: INFO) {
        self.error = error
        self.info = info
    }
}

extension String: Error {}

public enum OptionalPair<T1, T2> {
    case both(T1, T2)
    case first(T1)
    case second(T2)
    case none
}

public extension OptionalPair {
    init(_ t1: T1?, _ t2: T2?) {
        self = OptionalPair.from(t1, t2)
    }

    static func from(_ t1: T1?, _ t2: T2?) -> OptionalPair {
        if let t1 = t1, let t2 = t2 {
            return .both(t1, t2)
        }
        if let t1 = t1 {
            return .first(t1)
        }
        if let t2 = t2 {
            return .second(t2)
        }
        return .none
    }

    var first: T1? {
        switch self {
        case .first(let f):
            return f
        case .both(let f, _):
            return f
        default:
            return nil
        }
    }

    var second: T2? {
        switch self {
        case .second(let f):
            return f
        case .both(_, let f):
            return f
        default:
            return nil
        }
    }
}

public extension OptionalPair where T2 == Error {
    var asResult: Result<T1, Error> {
        switch self {
        case .both(let r, let e):
            return .failure(ErrorWithInfo(e, r))
        case .first(let r):
            return .success(r)
        case .second(let e):
            return .failure(e)
        case .none:
            return .failure("no result, no error")
        }
    }
}

public extension Result where Failure == Error {
    init(_ s: Success?, _ f: Error?) {
        self = OptionalPair(s, f).asResult
    }
}
