//
//  BoxMessage.swift
//  MyInst
//
//  Created by hoatruong on 7/30/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import Firebase

class BoxMessage {
    var boxID: String = ""
    var membersID: [String] = []
    
    let boxRef = Database.database().reference().child("box-message")
    
    init(boxID: String, membersID: [String]) {
        self.boxID = boxID
        self.membersID = membersID
    }
    init(snapshot: DataSnapshot) {
        self.boxID = snapshot.key
        for child in snapshot.children {
            let snap = child as! DataSnapshot
            membersID.append(snap.key)
        }
    }
    
    func createBox(completion: @escaping (_ boxID: String)-> Void) {
        checkIfBoxExisted { (idBox) in
            if idBox.isEmpty {
                let box = self.boxRef.childByAutoId()
                self.boxID = box.key!
                var dictMember: [String: String] = [:]
                for id in self.membersID {
                    dictMember[id] = "1"
                }
                box.setValue(dictMember)
                self.addBoxForUser(boxID: self.boxID)
                if let completion: (_ boxID: String) -> Void = completion {
                    completion(self.boxID)
                }
            } else {
                if let completion: (_ boxID: String) -> Void = completion {
                    completion(idBox)
                }
            }
        }
        
    }
    
    func checkIfBoxExisted(completion: @escaping (_ idBox: String) -> Void) {
        let box = boxRef.queryOrdered(byChild: membersID[0])
        box.queryEqual(toValue: "1").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let box = BoxMessage(snapshot: snap)
                print("box memeber check: \(box.membersID)")
                if self.checkSameMember(box: box) {
                    print("already existd")
                    completion(box.boxID)
                    return
                } else {
                    print("not existed")
                    completion("")
                    return
                }
                
            }
            print("not existed")
            completion("")
            
        }
    }
    
    func checkSameMember(box: BoxMessage) -> Bool {
        return self.membersID.sorted() == box.membersID.sorted()
    }
    func addBoxForUser(boxID: String) {
        for child in membersID {
            UserBox(userID: child, boxID: boxID).createUserBox()
        }
    }
    
}
