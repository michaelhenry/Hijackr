import Foundation

final public class Hijackr:URLProtocol {
  
  public struct Response {
    var statusCode:Int
    var headers:[String:String]
    var body:Data?
    
    public init(statusCode: Int, headers:[String:String] = [:], body:Data? = nil ) {
      self.statusCode = statusCode
      self.headers = headers
      self.body = body
    }
  }
  
  private static var responses:[Int: Response] = [:]
  
  public static func hijack(request: URLRequest, with response:Response) {
    responses[request.hashValue] = response
  }
  
  @discardableResult
  public static func register() -> Bool{
    return URLProtocol.registerClass(self.self)
  }
  
  public static func unregister() {
    URLProtocol.unregisterClass(self.self)
  }
  
  override public class func canInit(with request: URLRequest) -> Bool {
    if let _ = responses[request.hashValue] {
      return true
    }
    return false
  }
  
  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override public func startLoading() {
    guard let response = Hijackr.responses[request.hashValue],
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
