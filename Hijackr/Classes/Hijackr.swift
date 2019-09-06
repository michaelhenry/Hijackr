import Foundation

final public class Hijackr:URLProtocol {
  
  private static var responses:[Request: Response] = [:]
  
  public static func hijack(request: Request, with response:Response) {
    responses[request] = response
  }
  
  public static func hijack(
    url: URL,
    method: Request.Method = .get,
    with response:Response) {
    
    let request = Request(url: url, method: method)
    responses[request] = response
  }
  
  @discardableResult
  public static func register() -> Bool{
    return URLProtocol.registerClass(self.self)
  }
  
  public static func unregister() {
    // reset
    responses = [:]
    print("RESPONSES \(responses)")
    URLProtocol.unregisterClass(self.self)
  }
  
  override public class func canInit(with request: URLRequest) -> Bool {
    if let _ = responses[request.mockRequest] {
      return true
    }
    return false
  }
  
  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override public func startLoading() {
    guard let response = Hijackr.responses[request.mockRequest],
      let url = request.url
    else { fatalError("No response or url found.") }
    
    let httpResponse = HTTPURLResponse(
      url: url,
      statusCode: response.statusCode,
      httpVersion: nil,
      headerFields: response.headers)!

    client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
    if let body = response.body {
      client?.urlProtocol(self, didLoad: body)
    }
    client?.urlProtocolDidFinishLoading(self)
  }
  
  override public func stopLoading() {
    
  }
}
