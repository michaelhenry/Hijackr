import XCTest
import Hijackr

class Tests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    Hijackr.register()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    Hijackr.unregister()
  }
  
  func testCase1() {
    let request =  URLRequest(url: URL(string: "https://www.google.com")!)
    let response = Response(statusCode: 200, body: "hello1".data(using: .utf8))
    
    Hijackr.hijack(request: request.mockRequest, with: response)
  
    let ex = expectation(description: "expect to download a content")
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      XCTAssertNotNil(data)
      XCTAssertEqual(String(data: data!, encoding: .utf8), "hello1")
      ex.fulfill()
    }
    task.resume()
    wait(for: [ex], timeout: 2.0)
  }
  
  func testCase2() {
    let request =  URLRequest(url: URL(string: "https://www.google.com")!)
    let response = Response(statusCode: 200, body: "hello2".data(using: .utf8))
    
    Hijackr.hijack(url: URL(string: "https://www.google.com")!, with: response)
    let ex = expectation(description: "expect to download a content")
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      XCTAssertNotNil(data)
      XCTAssertEqual(String(data: data!, encoding: .utf8), "hello2")
      ex.fulfill()
    }
    task.resume()
    wait(for: [ex], timeout: 2.0)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure() {
      // Put the code you want to measure the time of here.
    }
  }
}

