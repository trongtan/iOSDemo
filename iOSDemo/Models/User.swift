//
//  User.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//


import Realm
import RealmSwift
import SwiftyJSON

public class User: Object {
  dynamic public var id = defaultNoneValue
  dynamic public var name = ""
  dynamic public var email = ""
  dynamic public var password = ""
  dynamic public var passwordConfirmation = ""
  dynamic public var gender = defaultNoneValue
  
  public init(id: Int, name: String, email: String, gender: Int) {
    super.init()
    self.id = id
    self.name = name
    self.email = email
    self.gender = gender
  }
  
  required public init() {
    super.init()
  }
  
  override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  public func genderName() -> String {
    if let gender = Gender(rawValue: self.gender) {
      return gender.description
    }
    return "(None)"
  }

  // MARK: Misc Methods

  public func validateSignInInfo() -> NSError? {
    return validateEmailAndPassword()
  }
  
  func validateEmailAndPassword() -> NSError? {
    if let apiHost = Util.Credential.getAPIHost() {
      if !email.isEmail() {
        return NSError(domain: apiHost, code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid email address"])
      }
      if count(password) < minimumPasswordLength {
        return NSError(domain: apiHost, code: -1, userInfo: [NSLocalizedDescriptionKey: "Password should be minimum 6 characters"])
      }
    }
    return nil
  }

  func processResponseAuthenticationData(data: JSON?) -> User? {
    var user: User?
    if let id = data?[User.primaryKey()!].int {
      let realm = Realm()
      realm.write {
        var cleanData = [String: AnyObject]()
        for (key, value) in enumerate(data!.dictionaryObject!) {
          if !(value.1 is NSNull) {
            cleanData[value.0] = value.1
          }
        }
        user = realm.create(User.self, value: cleanData, update: true)
        NSUserDefaults.standardUserDefaults().setObject(user!.id, forKey: currentUserIdKey)
        NSUserDefaults.standardUserDefaults().synchronize()
      }
    }
    return user
  }
}

// MARK: API

extension User {
  public func requestSignInWithCompletion(completion: ((User?, NSError?) -> Void)) {
    if let apiBaseUrl = Util.Credential.getBaseURL() {
      let parameters = [ "user": [ "email": email, "password": password ] ]
      HttpClient.sharedInstance.postRequestApiUrl(apiBaseUrl + signInPath, parameters: parameters) { (data: JSON?, error: NSError?) in
        completion(self.processResponseAuthenticationData(data), error)
      }
    }
  }
}
