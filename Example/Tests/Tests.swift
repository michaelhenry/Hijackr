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
  
  func testExample() {

    let request =  URLRequest(url: URL(string: "https://www.google.com")!)
    let response = Hijackr.Response(statusCode: 200, body: "hello".data(using: .utf8))
    Hijackr.hijack(request: request, with: response)
    let ex = expectation(description: "expect to download a content")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      XCTAssertNotNil(data)
      XCTAssertEqual(String(data: data!, encoding: .utf8), "hello")
      ex.fulfill()
    }
    task.resume()
    wait(for: [ex], timeout: 2.0)
    URLProtocol.unregisterClass(Hijackr.self)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure() {
      // Put the code you want to measure the time of here.
    }
  }
}

