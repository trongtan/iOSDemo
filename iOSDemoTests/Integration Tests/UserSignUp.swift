//
//  UserSignUp.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/27/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import UIKit
import XCTest

class SignUpTest: STLBaseTestCase {
  
  func testSuccessfulSignUp() {
    let stubDesc = OHHTTPStubs.stubResquestWithUrl("http://stubAPI/register", httpMethod: "POST", responseFilePath: "successfully_signup.json")
    tester.enterText("FirstName", intoViewWithAccessibilityLabel: "Sign Up - First Name")
    tester.enterText("LastName", intoViewWithAccessibilityLabel: "Sign Up - Last Name")
    tester.tapViewWithAccessibilityLabel("Sign Up - Email text field")
    tester.enterText("qwerty@qwerty.com", intoViewWithAccessibilityLabel: "Sign Up - Email text field")
    tester.enterText("123456", intoViewWithAccessibilityLabel: "Sign Up - Password text field")
    tester.enterText("123456", intoViewWithAccessibilityLabel: "Sign Up - Password confirmation text field")
    tester.tapViewWithAccessibilityLabel("Create Account Button")
    tester.waitForViewWithAccessibilityLabel("Sign up Successful")
    OHHTTPStubs.removeStub(stubDesc)
  }
}
