//
//  Message.swift
//  MyInst
//
//  Created by hoatruong on 7/29/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON
class Message {
    var messageID: String!
    var fromID: String!
    var date: String!
    var content: String!
    var boxID: String!
    
    let messageRef = Database.database().reference().child("message")
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.messageID = snapshot.key
        self.fromID = json["from"].stringValue
        self.content = json["content"].stringValue
        self.date = json["date"].stringValue
    }
    
    init(boxID: String, fromID: String, content: String) {
        self.boxID = boxID
        self.fromID = fromID
        self.content = content
    }
    
    func sendMessage() {
        let ref = messageRef.child(boxID).childByAutoId()
        let dict = [
            "content": content,
            "from": fromID,
            "date": "1234567"
        ]
        ref.setValue(dict)
    }
    
}
