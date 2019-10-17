import RHBFoundation
import XCTest

final class TaskManagerTests: XCTestCase {
    func testUrls() {
        let indexes = Array(0..<3)
        let datas: [Data] = indexes.map { _ in UUID().uuidString.data(using: .utf8)! }
        let urls: [URL] = datas.map {
            let url = RHBFoundationConstants.temporaryDirectoryUrl.appendingPathComponent(UUID().uuidString)
            try! $0.write(to: url)
            return url
        }
        let taskExpectations = indexes.map { expectation(description: "Task expectation for index: \($0)") }
        let manager: SharedTaskManager<Int, Data?> = SharedTaskManager()
        manager.createTask = { index, completion in
            let url = urls[index]
            let task = URLSession(configuration: .default).dataTask(with: url) { data, _, _ in
                completion(data)
                taskExpectations[index].fulfill()
            }
            task.resume()
            return DeinitBlock {
                task.cancel()
            }
        }
        var tasks: [DeinitBlock] = (indexes + indexes).enumerated().map { completionIndex, taskIndex in
            let exp = expectation(description: "Completion expectation for : \(completionIndex)")
            return manager.sharedTask(taskIndex) { result in
                XCTAssert(datas[taskIndex] == result)
                exp.fulfill()
            }
        }
        tasks.reverse()
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTwoCompletionsPerTask() {
        let indexes = Array(0..<10)
        let taskExpectations = indexes.map { expectation(description: "Task expectation for index: \($0)") }
        let manager: SharedTaskManager<Int, Void> = SharedTaskManager()
        manager.createTask = { index, completion in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                completion(())
                taskExpectations[index].fulfill()
            }
        }
        var tasks: [DeinitBlock] = (indexes + indexes).enumerated().map { completionIndex, taskIndex in
            let exp = expectation(description: "Completion expectation for index: \(completionIndex)")
            return manager.sharedTask(taskIndex) {
                exp.fulfill()
            }
        }
        tasks.reverse()
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCancelation() {
        let indexes = Array(0..<10)
        let taskExpectations = indexes.map { expectation(description: "Task expectation for index: \($0)") }
        let manager: SharedTaskManager<Int, Void> = SharedTaskManager()
        manager.createTask = { index, completion in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                completion(())
                taskExpectations[index].fulfill()
            }
        }
        let exp1 = expectation(description: "One completion left")
        var tasks: [DeinitBlock] = indexes.map { index in
            manager.sharedTask(index) {
                exp1.fulfill()
            }
        }
        tasks = Array(tasks.prefix(1))
        waitForExpectations(timeout: 1, handler: nil)
    }
}
