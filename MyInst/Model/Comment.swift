//
//  Comment.swift
//  MyInst
//
//  Created by hoatruong on 7/22/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class Comment {
    var postID: String!
    var userID: String!
    var message: String!
    
    var commentID: String! = ""
    
    init(postID: String, userID: String, message: String) {
        self.postID = postID
        self.userID = userID
        self.message = message
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.postID = json["postID"].stringValue
        self.userID = json["userID"].stringValue
        self.message = json["message"].stringValue
        self.commentID = snapshot.key
    }
    
    func save() {
        let commentRef = Database.database().reference().child("comments").child(postID).childByAutoId()
        
        let dic = [
            "postID": postID,
            "userID": userID,
            "message": message
        ]
        commentRef.setValue(dic)
    }
    
    
}
