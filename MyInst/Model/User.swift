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
    var nickName: String!
    var website: String!
    var bio: String!
    var gender: String!
    var photoURL: String!
    
    var email: String!
    var phone: String!
    
    var follower: DataSnapshot!
    var following: DataSnapshot!
    
    var imagePhoto: UIImage! = nil
    
    init(uid: String, displayName: String, nickName: String, website: String, bio: String, gender: String, photoURL: String, email: String, phone: String) {
        self.uid = uid
        self.displayName = displayName
        self.nickName = nickName
        self.website = website
        self.bio = bio
        self.gender = gender
        self.photoURL = photoURL
        self.email = email
        self.phone = phone
        
    }
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        uid = snapshot.key
        displayName = json["displayName"].stringValue
        nickName = json["nickName"].stringValue
        website = json["website"].stringValue
        bio = json["bio"].stringValue
        gender = json["gender"].stringValue
        photoURL = json["photoURL"].stringValue
        
        email = json["email"].stringValue
        phone = json["phone"].stringValue
     
    }
    
    func save() {
        let newUserRef = Database.database().reference().child("user").child(uid)
        
        let dict = [
            "displayName": displayName,
            "nickName": nickName,
            "website": website,
            "bio": bio,
            "gender": gender,
            "photoURL": photoURL,
            "email": email,
            "phone": phone
        ]
        
        newUserRef.setValue(dict)
    }
    
    func getAllFollowing(completion: @escaping (_ snapshot: DataSnapshot) -> Void)  {
        let userFollowing = Database.database().reference().child("user").child(uid).child("following")
        
        userFollowing.observe(.value) { (snapshot) in
            self.following = snapshot
            completion(self.following)
        }
    }
    func getAllFollower(completion: @escaping (_ snapshot: DataSnapshot) -> Void) {
        let userFollower = Database.database().reference().child("user").child(uid).child("follower")
        
        userFollower.observe(.value) { (snapshot) in
            self.follower = snapshot
            completion(self.follower)
        }
    }
    
    static func checkIfHadFollowedUser(id: String, followerID: String, completion: @escaping (_ yes: Bool) -> Void) {
        let userFollowing = Database.database().reference().child("user").child(id).child("following")
        
        userFollowing.observe(.value) { (snapshot) in
            completion(snapshot.hasChild(followerID))
        }
    }
    
    static func followUser(id: String, followerID: String, completion: @escaping () -> Void) {
        let userFollower = Database.database().reference().child("user").child(id).child("following").child(followerID)
        userFollower.setValue(["id": followerID])
        
        
        let userFollowing = Database.database().reference().child("user").child(followerID).child("follower").child(id)
        userFollowing.setValue(["id": id])
        
        
        completion()
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
