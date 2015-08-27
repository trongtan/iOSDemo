//
//  Util.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/25/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import Foundation

class Util: NSObject {
  class Credential {
    let infoDic = Util.readPlistFile()
    static func getParseAppID() -> String? {
      return Util.readPlistFile()?.objectForKey("CLParseApplicationID") as? String
    }

    static func getParseClientID() -> String? {
      return Util.readPlistFile()?.objectForKey("CLParseClientKey") as? String
    }
    
    static func getAPIHost() -> String? {
      return Util.readPlistFile()?.objectForKey("CLAPIHost") as? String
    }
    
    static func getBaseURL() -> String? {
      return Util.readPlistFile()?.objectForKey("CLBaseURL") as? String
    }
  }
}

// MARK - Misc Method
extension Util {
  static func readPlistFile() -> NSDictionary? {
    var infoDict: NSDictionary?
    if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
      infoDict = NSDictionary(contentsOfFile: path)
    }
    return infoDict
  }
}
