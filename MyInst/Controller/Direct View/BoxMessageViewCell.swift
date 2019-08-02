//
//  BoxMessageViewCell.swift
//  MyInst
//
//  Created by hoatruong on 7/31/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class BoxMessageViewCell: UITableViewCell {
    
    @IBOutlet var iv_boxs: [UIImageView]!
    @IBOutlet weak var lbl_boxName: UILabel!
    @IBOutlet weak var lbl_boxStatus: UILabel!
    
    private var boxMessage: BoxMessage!
    
    private var boxMembers: [User] = []
    private var lastMessage: Message!
    
    private var dispatchGroup = DispatchGroup()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit() {
        for iv_box in iv_boxs {
            iv_box.layer.masksToBounds = false
            iv_box.layer.cornerRadius = iv_box.frame.height/2
            iv_box.clipsToBounds = true
        }
    }
    
    func setBoxMessage(boxMessage: BoxMessage) {
        self.boxMessage = boxMessage
        loadAllBoxMember()
        loadLastMessage()
        dispatchGroup.notify(queue: .main) {
            print("box member: \(self.boxMembers.count)")
            self.UpdateUI()
        }
    }
    
    func UpdateUI() {
        lbl_boxName.text = ""
        for index in 0...(boxMembers.count - 1) {
            if index == 0 {
                lbl_boxName.text = boxMembers[index].nickName
            } else {
                lbl_boxName.text?.append(contentsOf: ", ")
                lbl_boxName.text?.append(contentsOf: boxMembers[index].nickName)
            }
            if index < 3 {
                if let usr: User = CacheUser.checkAndGetUser(id: boxMembers[index].uid){
                    iv_boxs[index].image = usr.imagePhoto
                } else {
                    Utilites.downloadImage(from: URL(string: boxMembers[index].photoURL!)!, id: boxMembers[index].uid) { (image) in
                        self.iv_boxs[index].image = image
                    }
                }
            }
        }
        unEnableAllBoxImageView(index: (boxMembers.count))
    }
    
    func loadAllBoxMember() {
        let currentUserUID = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference().child("user")
        for member in boxMessage.membersID {
            if member != currentUserUID {
                dispatchGroup.enter()
                userRef.child(member).observeSingleEvent(of: .value) { (snapshot) in
                    let user = User(snapshot: snapshot)
                    self.boxMembers.append(user)
                    print("box member: \(self.boxMembers.count)")
                    self.dispatchGroup.leave()
                }
            }
        }
        
    }
    
    func loadLastMessage() {
        let messageRef = Database.database().reference().child("message").child(boxMessage.boxID)
        messageRef.observe(.value) { (snapshot) in
            let snap = snapshot.children.allObjects[Int(snapshot.childrenCount - 1)] as! DataSnapshot
            self.lastMessage = Message(snapshot: snap)
            self.lbl_boxStatus.text = self.lastMessage.content
        }
    }
    
    func unEnableAllBoxImageView(index: Int) {
        if index >= iv_boxs.count {
            return
        }
        for i in index...(iv_boxs.count - 1) {
            iv_boxs[i].isHidden = true
        }
    }
    
}
