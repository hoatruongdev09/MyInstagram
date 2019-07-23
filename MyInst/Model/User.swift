//
//  User.swift
//  MyInst
//
//  Created by hoatruong on 7/20/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation

import Firebase
import SwiftyJSON

import UIKit

class User {
    var uid: String!
    var displayName: String!
    var photoURL: String!
    
    var email: String!
    var phone: String!
    
    var imagePhoto: UIImage! = nil
    
    init(uid: String, displayName: String, photoURL: String, email: String, phone: String) {
        self.uid = uid
        self.displayName = displayName
        self.photoURL = photoURL
        self.email = email
        self.phone = phone
        
    }
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        uid = snapshot.key
        displayName = json["displayName"].stringValue
        photoURL = json["photoURL"].stringValue
        
        email = json["email"].stringValue
        phone = json["phone"].stringValue
    }
    
    func save() {
        let newUserRef = Database.database().reference().child("user").child(uid)
        
        let dict = [
            "displayName": displayName,
            "photoURL": photoURL,
            "email": email,
            "phone": phone
        ]
        
        newUserRef.setValue(dict)
    }
    
    static func getUserInfoBy(id: String, completion: @escaping (_ usr: User) -> Void) {
        let userRef = Database.database().reference().child("user").child(id)
        
        userRef.observe(.value) { (snapshot) in
            let usr = User(snapshot: snapshot)
            completion(usr)
        }
    }
    static func getUserPhotoUrl(id: String, completion: @escaping (_ photoURL: String) -> Void) {
        let userRef = Database.database().reference().child("user").child(id).child("photoURL")
        
        userRef.observe(.value) { (snapshot) in
            let json = JSON(snapshot.value)
            completion(json["photoURL"].stringValue)
        }
    }
}
