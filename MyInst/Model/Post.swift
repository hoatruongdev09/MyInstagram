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
    private var image: UIImage!
    
    init(userUID: String, userName: String, caption: String, imageDownloadURL: String, postID: String) {
        self.userUID = userUID
        self.userName = userName
        self.caption = caption
        self.imageDownloadURL = imageDownloadURL
        
        image = nil
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.userName = json["userName"].stringValue
        self.caption = json["caption"].stringValue
        self.imageDownloadURL = json["imageDownloadURL"].stringValue
        self.userUID = json["userUID"].stringValue
        
        self.postID = snapshot.key
        
        //print("\(postID!) | \(userName!) | \(caption!) | \(imageDownloadURL!) | \(userUID!)")
    }
    
    func setImage(image: UIImage) {
        self.image = image
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
    
    func uploadImage(userrID: String, keyID: String,completion: @escaping (_ imageDownloadUrl: String) -> Void) {
        let imageStorageRef = Storage.storage().reference().child("images").child(userrID)
        if let fileData = image.jpegData(compressionQuality: 0.7) {
            let newImageRef = imageStorageRef.child(keyID)
            
            let uploadTask = newImageRef.putData(fileData, metadata: nil) { (metaData, error) in
                guard let metadata = metaData else {
                    print("error occur")
                    return
                }
                if let err = error {
                    print("upload data error : \(error?.localizedDescription)")
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
    
}
