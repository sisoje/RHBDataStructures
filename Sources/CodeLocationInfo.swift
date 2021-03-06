import Foundation

public final class CodeLocationInfo {
    let info: Any?
    let file: String
    let line: Int
    let function: String

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
}

extension CodeLocationInfo: LocalizedError {
    public var errorDescription: String? {
        "File: \(file) Line: \(line) Function: \(function) Info: \(String(describing: info))"
    }
}
