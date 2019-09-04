import Foundation

final public class Hijackr:URLProtocol {
  
  public struct Request:Hashable {
    public enum Method:String {
      case get
      case head
      case post
      case patch
      case put
      case delete
      case connect
      case options
      case trace
    }
  
    var method:Method
    var url:URL
    
    public init(url:URL, method: Method = .get) {
      self.url = url
      self.method = method
    }
  }
  
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
  
  private static var responses:[Request: Response] = [:]
  
  public static func hijack(request: Request, with response:Response) {
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

private extension URLRequest {
  
  var mockRequest:Hijackr.Request {
    return Hijackr.Request(url: url!, method: Hijackr.Request.Method(rawValue: httpMethod?.lowercased()!)!)
  }
}
