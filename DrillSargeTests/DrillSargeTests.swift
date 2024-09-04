/*

 MIT License

 Copyright (c) 2024 Harry Lundström

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import XCTest
@testable import DrillSarge

final class DrillSargeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        // .measure {
        // Put the code you want to measure the time of here.
        // }
    }

    func testParseFromPersistentStorage() {

        let json = "{\"programs\":[{\"exercises\":[{\"name\":\"mock exercise 1\",\"duration\":30},{\"duration\":15,\"name\":\"mock exercise 2\"},{\"duration\":15,\"name\":\"mock exercise 3\"}],\"name\":\"mock program 1\"},{\"name\":\"mock program 2\",\"exercises\":[{\"name\":\"mock exercise 4\",\"duration\":30},{\"name\":\"mock exercise 5\",\"duration\":15},{\"duration\":15,\"name\":\"mock exercise 6\"}]}],\"voiceName\":\"\"}"

        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }

        let persistentStorage: PersistentStorage = try! JSONDecoder().decode(PersistentStorage.self, from: data)
        
        XCTAssertNotNil(persistentStorage)
    }

    func testParseFromPersistentStorageMissingVoiceName() {

        let json = "{\"programs\":[{\"exercises\":[{\"name\":\"mock exercise 1\",\"duration\":30},{\"duration\":15,\"name\":\"mock exercise 2\"},{\"duration\":15,\"name\":\"mock exercise 3\"}],\"name\":\"mock program 1\"},{\"name\":\"mock program 2\",\"exercises\":[{\"name\":\"mock exercise 4\",\"duration\":30},{\"name\":\"mock exercise 5\",\"duration\":15},{\"duration\":15,\"name\":\"mock exercise 6\"}]}]}"

        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }

        let persistentStorage: PersistentStorage = try! JSONDecoder().decode(PersistentStorage.self, from: data)

        XCTAssertNotNil(persistentStorage)
    }

    func testParseFromPersistentStorageMissingExercises() {

        let json = "{\"programs\":[{\"exercises\":[],\"name\":\"mock program 1\"},{\"name\":\"mock program 2\",\"exercises\":[{\"name\":\"mock exercise 4\",\"duration\":30},{\"name\":\"mock exercise 5\",\"duration\":15},{\"duration\":15,\"name\":\"mock exercise 6\"}]}]}"

        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }

        let persistentStorage: PersistentStorage = try! JSONDecoder().decode(PersistentStorage.self, from: data)

        XCTAssertNotNil(persistentStorage)
    }

    func testParseFromPersistentStorageMissingPrograms() {

        let json = "{\"programs\":[]}"

        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }

        let persistentStorage: PersistentStorage = try! JSONDecoder().decode(PersistentStorage.self, from: data)

        XCTAssertNotNil(persistentStorage)
    }
}
