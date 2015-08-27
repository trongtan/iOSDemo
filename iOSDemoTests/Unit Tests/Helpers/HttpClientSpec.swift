//
//  HttpClientSpec.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import iOSDemo
import SwiftyJSON
import Quick
import Nimble
import OHHTTPStubs

class HttpClientSpec: QuickSpec {

  override func spec() {
    
    afterEach {
      OHHTTPStubs.removeAllStubs()
    }
    
    describe("#postRequestApiUrl()") {
      context("server responded with data") {
        context("data contain error and message attribute") {
          let expectedErrorCode = 401
          
          beforeEach {
            OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
          }
          
          it("should call completion closure with NSError") {
            var actualJson: JSON?
            var actualError: NSError?
            let expectedErrorDescription = "internal server error"
            let apiBaseUrl = Util.Credential.getBaseURL()
            HttpClient.sharedInstance.postRequestApiUrl(apiBaseUrl!, parameters: nil, completion: { (json: JSON?, error: NSError?) in
              actualJson = json
              actualError = error
            })
            
            expect(actualJson).toEventually(beNil())
            expect(actualError?.isMemberOfClass(NSError.self)).toEventually(beTruthy())
            expect(actualError?.code).toEventually(equal(expectedErrorCode))
            expect(actualError?.localizedDescription).toEventually(equal(expectedErrorDescription))
          }
        }
        
        context("data does not contain error") {
          beforeEach {
            OHHTTPStubs.stubAuthenticationRequest()
          }
          
          it("should call completion closure with Json data") {
            var actualJson: JSON?
            var actualError: NSError?
            let apiBaseUrl = Util.Credential.getBaseURL()
            HttpClient.sharedInstance.postRequestApiUrl(apiBaseUrl! + signInPath, parameters: nil, completion: { (json: JSON?, error: NSError?) in
              actualJson = json
              actualError = error
            })
            
            expect(actualJson?["email"]).toEventually(equal("tan.vu@eastagile.com"))
            expect(actualError).to(beNil())
            
          }
        }
      }
      
      context("server didn't respond any data") {
        beforeEach {
          let apiHost = Util.Credential.getAPIHost()
          OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == apiHost! }) { _ in
            return OHHTTPStubsResponse(data: NSData(),
              statusCode: 200, headers: ["Content-Type":"application/json"])
          }
        }
        
        it("should call completion closure with default http request NSError") {
          var actualJson: JSON?
          var actualError: NSError?
          let apiBaseUrl = ""
          HttpClient.sharedInstance.postRequestApiUrl(apiBaseUrl, parameters: nil, completion: { (json: JSON?, error: NSError?) in
            actualJson = json
            actualError = error
          })
          expect(actualJson).toEventually(beNil())
          expect(actualError).toEventually(beNil())
        }
      }
    }
  }
}
