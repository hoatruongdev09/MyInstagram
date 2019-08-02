//
//  Post.swift
//  MyPin
//
//  Created by hoatruong on 7/19/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftyJSON

class Post {
    var caption: String!
    var userUID: String!
    var userName: String!
    var imageDownloadURL: String!
    var postID: String! = ""
    var postLiker: [String] = []
    private var image: UIImage! {
        didSet {
            imageSetEvent()
        }
    }
    
    var imageSetEvent = {() -> () in}
    
    
    init(userUID: String, userName: String, caption: String, imageDownloadURL: String, postID: String) {
        self.userUID = userUID
        self.userName = userName
        self.caption = caption
        self.imageDownloadURL = imageDownloadURL
        
        
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.userName = json["userName"].stringValue
        self.caption = json["caption"].stringValue
        self.imageDownloadURL = json["imageDownloadURL"].stringValue
        self.userUID = json["userUID"].stringValue
        self.postID = snapshot.key
        
        Utilites.downloadImage(from: URL(string: imageDownloadURL)!, id: postID) { (image) in
            self.image = image
        }
        
        //print("\(postID!) | \(userName!) | \(caption!) | \(imageDownloadURL!) | \(userUID!)")
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    func getImage() -> UIImage! {
        return image
    }
    
    func save() {
        
        let newPostRef = Database.database().reference().child("post").childByAutoId()
        let newPostKey = newPostRef.key
        postID = newPostKey
        
        
        
        uploadImage(userrID: userUID, keyID: newPostKey!) { (downloadURl) in
            let newDict = [
                "imageDownloadURL": downloadURl,
                "caption": self.caption,
                "userUID": self.userUID,
                "userName": self.userName
            ]
            
            newPostRef.setValue(newDict)
        }
    }
    func getAllLiker(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("post").child(self.postID).child("liker")
        ref.observe(.childAdded) { (snapshot) in
            print("liker id: \(snapshot.key)")
            self.postLiker.append(snapshot.key)
            completion()
        }
    }
    func addLiker(userID : String) {
        let ref = Database.database().reference().child("post").child(self.postID).child("liker").child(userID)
        ref.setValue(["id": userID])
    }
    func removeLiker(userID: String) {
        let ref = Database.database().reference().child("post").child(self.postID).child("liker").child(userID)
        ref.removeValue()
    }
    
    func checkIfUserLiked(userID: String) -> Bool {
        print("\(self.postID) liker: \(self.postLiker)")
        for id in postLiker {
            if userID == id {
                return true
            }
        }
        return false
    }
    
    func uploadImage(userrID: String, keyID: String,completion: @escaping (_ imageDownloadUrl: String) -> Void) {
        let imageStorageRef = Storage.storage().reference().child("images").child(userrID)
        if let fileData = image.jpegData(compressionQuality: 0.6) {
            let newImageRef = imageStorageRef.child(keyID)
            
            newImageRef.putData(fileData, metadata: nil) { (metaData, error) in
                guard metaData != nil else {
                    print("error occur")
                    return
                }
                if let err = error {
                    print("upload data error : \(err.localizedDescription)")
                }else {
                    newImageRef.downloadURL(completion: { (url, error) in
                        if let err = error {
                            print("download url error: \(err.localizedDescription)")
                        } else {
                          completion(url!.absoluteString)
                        }
                    })
                }
            }
        }
    }
    
    static func countPostFor(userID: String, completion: @escaping (_ count: Int) -> Void) {
        let postRef = Database.database().reference().child("post")
        var count = 0
        postRef.queryOrdered(byChild: "userUID").observe(.childAdded) { (snapshot) in
            count += 1
            print("count post: \(count)")
        }
        completion(count)
    }
   
    
}
