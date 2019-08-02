//
//  UserBox.swift
//  MyInst
//
//  Created by hoatruong on 7/30/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import Firebase

class UserBox {
    var userID: String = ""
    var boxID: String = ""
    
    let userBoxRef = Database.database().reference().child("user-box")
    
    init(userID: String, boxID: String) {
        self.userID = userID
        self.boxID = boxID
    }
    
    func createUserBox() {
        let ref = userBoxRef.child(userID).child(boxID)
        ref.setValue([boxID: "1"])
    }
    
}
