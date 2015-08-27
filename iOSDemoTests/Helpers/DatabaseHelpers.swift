//
//  DatabaseHelpers.swift
//  iOSDemo
//
//  Created by Tan Vu on 8/26/15.
//  Copyright (c) 2015 EastAgile. All rights reserved.
//

import Foundation
import RealmSwift

//let testRealmPath = "/tmp/test_realm_path.realm"

func cleanDatabase() {
  let realm = Realm()
  realm.write {
    realm.deleteAll()
  }
}
