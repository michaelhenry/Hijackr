//
//  URLRequest_Extensions.swift
//  Hijackr
//
//  Created by Michael Henry Pantaleon on 2019/09/06.
//

import Foundation
public extension URLRequest {
  
  var mockRequest:Request {
    guard let _url = url else { fatalError("URL must not be nil.") }
    guard let _method = httpMethod, let reqMethod = Request.Method(rawValue: _method.lowercased()) else { fatalError("Please check the request method!") }
    return Request(url: _url, method:reqMethod)
  }
}
