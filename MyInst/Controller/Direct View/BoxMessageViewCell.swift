//
//  BoxMessageViewCell.swift
//  MyInst
//
//  Created by hoatruong on 7/31/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class BoxMessageViewCell: UITableViewCell, DirectCellProtocol {
   
    
    
    @IBOutlet var iv_boxs: [UIImageView]!
    @IBOutlet weak var lbl_boxName: UILabel!
    @IBOutlet weak var lbl_boxStatus: UILabel!
    
    private var boxMessage: BoxMessage!
    
    private var boxMembers: [User] = []
    private var lastMessage: Message!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(data: Any) {
        if let boxMessageData : BoxMessage = data as? BoxMessage {
            setBoxMessage(boxMessage: boxMessageData)
        }
    }
    
    func commonInit() {
        for iv_box in iv_boxs {
            iv_box.layer.masksToBounds = false
            iv_box.layer.cornerRadius = iv_box.frame.height/2
            iv_box.clipsToBounds = true
            iv_box.isHidden = true;
        }
    }
    
    func setBoxMessage(boxMessage: BoxMessage) {
        self.boxMessage = boxMessage
        loadAllBoxMember()
        loadLastMessage()
    }
    func getBoxMessage() -> BoxMessage {
        return boxMessage
    }
    
    func loadAllBoxMember() {
        let boxRef = Database.database().reference().child("box-message").child(boxMessage.boxID)
        var index = 0
        boxRef.observe(.childAdded) { (snapshot) in
            let userRef = Database.database().reference().child("user").child(snapshot.key)
            if snapshot.key != Auth.auth().currentUser!.uid {
                userRef.observeSingleEvent(of: .value, with: { (data) in
//                    let json = JSON(data.value ?? "")
//                    let photoURL = json["photoURL"].stringValue
//                    let userName = json["nickName"].stringValue
                    let user = User(snapshot: data)
                    self.boxMembers.append(user)
                    if index == 0 {
                        self.lbl_boxName.text = user.nickName
                    } else {
                        self.lbl_boxName.text?.append(contentsOf: ", \(user.nickName)")
                    }
                    if index < 3 {
                        Utilites.downloadImage(from: URL(string: user.photoURL)!, id: user.uid, completion: { (image) in
                            DispatchQueue.main.async {
                                self.iv_boxs[index].image = image
                                self.iv_boxs[index].isHidden = false
                            }
                            
                        })
                    }
                    index += 1
                })
            }
           
        }
        
    }
    
    func loadLastMessage() {
        let messageRef = Database.database().reference().child("message").child(boxMessage.boxID)
        messageRef.observe(.value) { (snapshot) in
            if snapshot.childrenCount != 0 {
                let snap = snapshot.children.allObjects[Int(snapshot.childrenCount - 1)] as! DataSnapshot
                self.lastMessage = Message(snapshot: snap)
                self.lbl_boxStatus.text = self.lastMessage.content
            } else {
                self.lbl_boxStatus.text = ""
            }
            
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
