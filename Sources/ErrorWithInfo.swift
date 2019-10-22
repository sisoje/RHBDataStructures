import Foundation

public struct ErrorWithInfo: LocalizedError {
    public let info: Any?
    public let file: String
    public let line: Int
    public let function: String

    public init(
        _ info: Any? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        self.info = info
        self.line = line
        self.file = file
        self.function = function
    }

    public var errorDescription: String? {
        "File: \(file) Line: \(line) Function: \(function) Info: \(String(describing: info))"
    }
}
