import Foundation

public extension Decodable {
    static func jsonCompletionHandler(jsonDecoder: JSONDecoder = JSONDecoder(), _ block: @escaping (Self?, Data?, URLResponse?, Error?) -> Void) -> (Data?, URLResponse?, Error?) -> Void {
        return { block($0?.jsonObject(jsonDecoder: jsonDecoder), $0, $1, $2) }
    }
}

public extension Data {
    func jsonObject<T: Decodable>(jsonDecoder: JSONDecoder = JSONDecoder()) -> T? {
        return try? jsonDecoder.decode(T.self, from: self)
    }
    init<T: Encodable>(jsonObject: T, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        self = try jsonEncoder.encode(jsonObject)
    }
}
