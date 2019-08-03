//
//  BoxMessage.swift
//  MyInst
//
//  Created by hoatruong on 8/3/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import Firebase

class BoxMessage {
    var boxID: String = ""
    var members: [String] = []
    
    let boxMessageRef = Database.database().reference().child("box-message")
    let userBoxMessage = Database.database().reference().child("box-user")
    
    init(members: [String]) {
        self.members = members
    }
    
    init(snapshot: DataSnapshot) {
        boxID = snapshot.key
        for child in snapshot.children {
            let childSnapshot = child as! DataSnapshot
            members.append(childSnapshot.key)
        }
    
    }
    
    func createBox(completion: @escaping (_ boxID: String) -> Void) {
        checkIfABoxExist { (exist, box) in
            if exist {
                self.boxID = box!.boxID
                self.members = box!.members
            } else {
                print("box not exist")
                let boxRef = self.boxMessageRef.childByAutoId()
                self.boxID = boxRef.key!
                var dictMember: [String: String] = [:]
                
                
                for member in self.members {
                    dictMember[member] = "1"
                    self.userBoxMessage.child(member).child(self.boxID).setValue(["boxID": self.boxID])
                }
                boxRef.setValue(dictMember)

            }
            
            completion(self.boxID)
        }
//
        
    }
    
    private func checkIfABoxExist(completion: @escaping (Bool, BoxMessage?) -> Void) {
        let box = self.boxMessageRef.queryOrdered(byChild: self.members[0]).queryEqual(toValue: "1")
        box.observeSingleEvent(of: .value) { (groupSnapShot) in
            var exist = false
            var boxMessage: BoxMessage? = nil
            for child in groupSnapShot.children {
                let box = BoxMessage(snapshot: child as! DataSnapshot)
                if self.checkSameMember(box: box) {
                    print("already exist")
                    exist = true
                    boxMessage = box
                    break
                }
            }
            
            completion(exist, boxMessage)
        }
    }
    private func checkSameMember(box: BoxMessage) -> Bool {
        return self.members.sorted() == box.members.sorted()
    }
}
