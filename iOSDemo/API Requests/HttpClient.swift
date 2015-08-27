//
//  HttpClient.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

public class HttpClient {

  let manager = Alamofire.Manager.sharedInstance

  public class var sharedInstance: HttpClient {
    struct Static {
      static let instance: HttpClient = HttpClient()
    }
    return Static.instance
  }

  public func postRequestApiUrl(url: String, parameters: [String: AnyObject]?, completion: ((JSON?, NSError?) -> Void)) {
    request(.POST, url: url, parameters: parameters, completion: completion)
  }

  func request(method: Alamofire.Method, url: String, parameters: [String: AnyObject]?, completion: ((JSON?, NSError?) -> Void)) {
    manager.request(method, url, parameters: parameters, encoding: .JSON)
      .validate()
      .response { (request, response, data, error) in
        if let data: AnyObject = data {
          let json = JSON(data: data as! NSData)
          if let errorMessage = json["errors"].string {
            let responseError = NSError(domain: "", code: response!.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            completion(nil, responseError)
          } else {
            completion(json, error)
          }
        } else {
          completion(nil, error)
        }
    }
  }
}
