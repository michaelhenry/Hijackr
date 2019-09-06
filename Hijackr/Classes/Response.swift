//
//  Response.swift
//  Hijackr
//
//  Created by Michael Henry Pantaleon on 2019/09/06.
//

import Foundation

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
