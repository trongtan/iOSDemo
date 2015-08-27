//
//  UserSpec.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import iOSDemo
import RealmSwift
import Quick
import Nimble
import OHHTTPStubs

class UserSpec: QuickSpec {
  
  override func spec() {
    var user = User()
    let invalidEmail = "UsernameInvalidgmail.com"
    let validEmail = "UserValid@gmail.com"
    let invalidPassword = "1234"
    let validPassword = "123456"
    
    beforeEach {
      user = User(id: 10, name: "UserName", email: validEmail, gender: Gender.Men.rawValue)
      user.password = validPassword
      user.passwordConfirmation = validPassword
    }
    
    afterEach {
      NSUserDefaults.standardUserDefaults().removeObjectForKey(currentUserIdKey)
      NSUserDefaults.standardUserDefaults().synchronize()
      OHHTTPStubs.removeAllStubs()
    }
    
    describe("#genderName()") {
      context("Valid gender value") {
        it("should returns gender description") {
          user.gender = Gender.Men.rawValue
          expect(user.genderName()).to(equal(Gender.Men.description))
        }
      }
      
      context("Invalid gender value") {
        it("should returns (None)") {
          user.gender = defaultNoneValue
          expect(user.genderName()).to(equal("(None)"))
        }
      }
    }
    
    describe("#requestSignInWithCompletion") {
      context("server return valid user data") {
        beforeEach {
          OHHTTPStubs.stubAuthenticationRequest()
        }
        
        it("should add user to database and set value for key: currentUserIdKey") {
          let expectedUserId = 1
          var actualReceivedUser: User?
          user.requestSignInWithCompletion({ (signedUpUser: User?, error: NSError?) in
            actualReceivedUser = signedUpUser
          })
          
          expect(actualReceivedUser?.id).toEventually(equal(expectedUserId))
          expect(Realm().objects(User).first?.id).to(equal(expectedUserId))
          expect(NSUserDefaults.standardUserDefaults().objectForKey(currentUserIdKey) as? Int).to(equal(expectedUserId))
        }
      }
      
      context("server return errors") {
        let expectedErrorCode = 401
        
        beforeEach {
          OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
        }
        
        it("should not add user to database and set value for key: currentUserIdKey") {
          var actualReceivedUser: User?
          var responseError: NSError?
          user.requestSignInWithCompletion({ (signedUpUser: User?, error: NSError?) in
            actualReceivedUser = signedUpUser
            responseError = error
          })
          
          expect(actualReceivedUser).toEventually(beNil())
          expect(responseError?.code).toEventually(equal(expectedErrorCode))
          expect(Realm().objects(User).count).to(equal(0))
          expect(NSUserDefaults.standardUserDefaults().objectForKey(currentUserIdKey) as? Int).to(beNil())
        }
        
      }
      
    }
  }
}