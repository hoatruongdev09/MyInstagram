//
//  CacheUser.swift
//  MyInst
//
//  Created by hoatruong on 7/22/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation

 class CacheUser {
    static var dicUser: [String: User] = [:]
    
    
    static func checkAndGetUser(id: String) -> User? {
        if dicUser[id] != nil {
            return dicUser[id]
        }
        return nil
    }
    static func addToCache (usr: User) {
        if checkAndGetUser(id: usr.uid) == nil {
            dicUser[usr.uid] = usr
        }
    }
}
