//
//  Constant.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import Foundation

public let minimumPasswordLength = 6
public let defaultNoneValue = -1

// MARK: API Entry Point
public let signInPath = "/signIn"

// MARK: NSUserDefault Keys
public let currentUserIdKey = "currentUserIdKey"

// MARK: Gender

public enum Gender: Int, Printable {
  case Men = 0
  case Women
  
  public var description: String {
    switch self {
      case .Men: return "Men"
      case .Women: return "Woman"
    }
  }
  
  static func startValue() -> Int {
    return self.Men.rawValue
  }
}
