import RHBFoundation
import XCTest
import RHBFoundationTestUtilities

extension URLResponse {
    static let dummy = URLResponse(url: URL(fileURLWithPath: ""), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

let convert: (DataTaskData) -> Result<String, Error> = { dataTaskData in
    dataTaskData.first
        .flatMap { String(data: $0, encoding: .utf8) }
        .map { .success($0) }
        ?? .failure(ErrorWithInfo("can not create string", dataTaskData))
}

let datas: [Data?] = [
    "hello".data(using: .utf8)!,
    Data(repeating: 255, count: 10),
    nil,
]

let responses: [URLResponse?] = [
    .dummy,
    nil,
]

let errors: [Error?] = [
    "test error",
    nil,
]

let combined: [(Data?, URLResponse?, Error?)] = {
    var c: [(Data?, URLResponse?, Error?)] = []
    datas.forEach { data in
        responses.forEach { response in
            errors.forEach { error in
                c.append((data, response, error))
            }
        }
    }
    return c
}()

class TestSession {
    let q = OperationQueue() ~ {
        $0.maxConcurrentOperationCount = 4
    }

    var totalTasks = 0
    var taskRunner: ((Int, @escaping DataTaskCompletionBlock) -> DeinitBlock)!
    init() {
        taskRunner = { [unowned self] index, completion in
            var cancelToken: NSObject? = NSObject()
            self.q.addOperation { [weak cancelToken] in
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    guard cancelToken != nil else {
                        return
                    }
                    self.totalTasks += 1
                    let comb = combined[index]
                    completion(comb.0, comb.1, comb.2)
                }
            }
            return DeinitBlock { cancelToken = nil }
        }
    }
}

class FillfilerTests: XCTestCase {
    func testFulfillWithDispatchQueue() {
        let queue = DispatchQueue(label: #function)
        (0 ..< 10).forEach { index in
            let fulfiller = expectation(description: "\(#function) \(index)").fulfiller
            if index.isMultiple(of: 2) {
                // not retained -> automatically fulfilled
                return
            }
            queue.async {
                // fullfiled when closure is released
                print("Retaining: \(fulfiller)")
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}

final class ImageCacheTests: XCTestCase {
    var deiniters: [Any] = []
    var session: TestSession!

    override func setUp() {
        deiniters = []
        session = TestSession()
    }

    func testFromGithub() {
        let session = URLSession(configuration: .default)
        let trunner: ((Int, @escaping DataTaskCompletionBlock) -> DeinitBlock)! = { index, completion in
            let url = "https://raw.githubusercontent.com/sisoje/githubfiles/master/sabbath_jsons/\(1_015_094 + index).json"
            return session.dataTask(with: URL(string: url)!, completionHandler: completion).runner
        }

        let t: TaskCompletionManager = TaskCompletionManager(dataMapper: convert, taskRunner: trunner)
        var completedCount = 0
        let N = 10
        let amountToCancel = 3
        var taskRunners: [Any] = []
        (0 ..< N).forEach { index in
            let ex = expectation(description: String(index)).fulfiller
            let task = t.managedTask(index / 2) { _ in
                completedCount += 1
                _ = ex
            }
            taskRunners.append(task)
        }
        taskRunners = Array(taskRunners.suffix(from: amountToCancel))
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
            XCTAssert(completedCount == N - amountToCancel)
        }
    }

    func testCancel() {
        let t: TaskCompletionManager = TaskCompletionManager(dataMapper: convert, taskRunner: session.taskRunner)
        (0 ..< 3).forEach { _ in
            (0 ..< combined.count).forEach {
                _ = t.managedTask($0) { _ in
                    XCTFail()
                }
            }
        }
        XCTAssert(session.totalTasks == 0, "\(session.totalTasks)")
    }

    func testAllCombinations() {
        let t: TaskCompletionManager = TaskCompletionManager(dataMapper: convert, taskRunner: session.taskRunner)
        let N = 3
        var totalcompletions = 0
        var sucesses = 0
        (0 ..< N).forEach { n in
            combined.enumerated().forEach { i, _ in
                let ex = expectation(description: String("\(i)-\(n)"))
                let task = t.managedTask(i) { result in
                    totalcompletions += 1
                    if let r = try? result.get() {
                        sucesses += 1
                        XCTAssert(r == "hello")
                    }
                    ex.fulfill()
                }
                deiniters.append(task)
            }
        }
        waitForExpectations(timeout: TimeInterval(N)) { err in
            self.deiniters = []
            XCTAssert(err == nil)
            XCTAssert(sucesses == 2 * N, "\(sucesses)")
            XCTAssert(self.session.totalTasks == combined.count, "\(self.session.totalTasks) \(combined.count)")
            XCTAssert(totalcompletions == self.session.totalTasks * N, "\(totalcompletions) \(self.session.totalTasks * N)")
        }
    }
}
