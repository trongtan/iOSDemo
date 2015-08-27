//
//  OHHTTPStubs+Extension.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import iOSDemo
import OHHTTPStubs

extension OHHTTPStubs {
  class func stubAuthenticationRequest() {
    let apiHost = Util.Credential.getAPIHost()
    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == apiHost && ($0.URL!.path == signInPath) }) { _ in
      let fixture = OHPathForFile("user_data_response.json", UserSpec.self)
      return OHHTTPStubsResponse(fileAtPath: fixture!,
        statusCode: 200, headers: ["Content-Type":"application/json"])
    }
  }
  
  class func stubErrorRequestWithErrorCode(errorCode: Int32) {
    let apiHost = Util.Credential.getAPIHost()
    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == apiHost }) { _ in
      let fixture = OHPathForFile("error_response.json", UserSpec.self)
      return OHHTTPStubsResponse(fileAtPath: fixture!,
        statusCode: errorCode, headers: ["Content-Type":"application/json"])
    }
  }
  
}
