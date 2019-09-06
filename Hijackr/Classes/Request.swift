//
//  Request.swift
//  Hijackr
//
//  Created by Michael Henry Pantaleon on 2019/09/06.
//

import Foundation

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
