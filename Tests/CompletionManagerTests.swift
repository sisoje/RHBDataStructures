import RHBFoundation
import XCTest
import RHBFoundationTestUtilities

let datas: [Data?] = [
    "hello".data(using: .utf8)!,
    Data(repeating: 255, count: 10),
    nil,
]

let errors: [Error?] = [
    NSError(domain: "", code: 0, userInfo: nil),
    nil,
]

let combined: [(Data?, Error?)] = (0..<datas.count*errors.count).map {
    (datas[$0 / errors.count], errors[$0 % errors.count])
}

final class TaskCompletionManagerTests: XCTestCase {
    func testJsons() {
        let N = 10
        let jsons = (0..<N).map { "{\"\($0)\":\"\($0)\"}" }
        let urls = (0..<N).map { URL.temporary.appendingPathComponent("\($0)") }
        zip(urls, jsons).forEach {
            try! $0.1.data(using: .utf8)!.write(to: $0.0)
        }
        let manager: CompletionManager<Int, Result<[Int:String], Error>> = CompletionManager(queue: DispatchQueue(label: #function))
        manager.createTask = { index, completion in
            let url = urls[index]
            let task = URLSession(configuration: .default).dataTask(with: url) { data,_,error in
                let result = Result(data, error).railMap {
                    try JSONDecoder().decode([Int:String].self, from: $0)
                }
                completion(result)
            }
            return task.runner
        }

        var completedCount = 0
        let amountToCancel = 3
        var taskRunners: [Any] = []
        (0 ..< N).forEach { index in
            let ex = expectation(description: String(index)).fulfiller
            let task = manager.sharedTask(index) { result in
                let dic = try! result.get()
                XCTAssert(dic[index] == "\(index)")
                completedCount += 1
                ex.noop()
            }
            taskRunners.append(task)
        }
        taskRunners = Array(taskRunners.suffix(from: amountToCancel))
        waitForExpectations(timeout: 3) { error in
            XCTAssertNil(error)
            XCTAssert(completedCount == N - amountToCancel)
        }
    }

    func testAllCombinations() {
        var totaltasks = 0
        let manager: CompletionManager<Int, Result<String, Error>> = CompletionManager(queue: DispatchQueue(label: #function))
        manager.createTask = { index, completion in
            totaltasks += 1
            let token = NSObject()
            DispatchQueue.global().asyncAfter(deadline: .now()+0.5) { [weak token] in
                token.map { _ in
                    let comb = combined[index]
                    let result = Result(comb.0, comb.1).railMap {
                        String(data: $0, encoding: .utf8)
                    }
                    completion(result)
                }
            }
            return token
        }
        let N = 3
        var totalcompletions = 0
        var sucesses = 0
        var tasks: [Any] = []
        (0 ..< N).forEach { n in
            combined.enumerated().forEach { i, _ in
                let ex = expectation(description: String("\(i)-\(n)")).fulfiller
                let task = manager.sharedTask(i) { result in
                    totalcompletions += 1
                    if let r = try? result.get() {
                        sucesses += 1
                        XCTAssert(r == "hello")
                    }
                    ex.noop()
                }
                tasks.append(task)
            }
        }
        waitForExpectations(timeout: TimeInterval(N)) { err in
            XCTAssert(err == nil)
            XCTAssert(sucesses == N)
            XCTAssert(totalcompletions == N*combined.count)
            XCTAssert(totaltasks == combined.count)
        }
    }
}
