//
//  String+Extension.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import Foundation

extension String {
  func isEmail() -> Bool {
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(self)
  }
}
