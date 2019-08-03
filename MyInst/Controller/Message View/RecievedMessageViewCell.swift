//
//  RecievedMessageViewCell.swift
//  MyInst
//
//  Created by hoatruong on 7/29/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//
import UIKit

class RecievedMessageViewCell: UITableViewCell {
    @IBOutlet weak var iv_userAvatar: UIImageView!
    
    @IBOutlet weak var lbl_content: UILabel!
    
    var message: Message!
    var user: User!
    
    private var dispatchGroup = DispatchGroup()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initializeCell() {
        iv_userAvatar.layer.borderWidth = 1
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.borderColor = UIColor.black.cgColor
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
    }
    
    func setMessage(msg: Message) {
        message = msg
        lbl_content.text = message.content
    }
    
    
    func setUser(usr: User) {
        user = usr
        
        if let tmp: User = CacheUser.checkAndGetUser(id: user.uid!){
            self.iv_userAvatar.image = tmp.imagePhoto
            
        } else {
            Utilites.downloadImage(from: URL(string: user.photoURL!)!, id: user.uid) { (image) in
                self.iv_userAvatar.image = image
            }
        }
    }
    
}
