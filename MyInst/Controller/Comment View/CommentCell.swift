//
//  CommentCell.swift
//  MyInst
//
//  Created by hoatruong on 7/22/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var iv_avatar: UIImageView!
    @IBOutlet weak var lbl_comment: UILabel!
    
    var comment: Comment! = nil
    
    private var user: User! = nil
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
        iv_avatar.layer.borderWidth = 1
        iv_avatar.layer.masksToBounds = false
        iv_avatar.layer.borderColor = UIColor.black.cgColor
        iv_avatar.layer.cornerRadius = iv_avatar.frame.height/2
        iv_avatar.clipsToBounds = true
    }
    
    func setComment(_ cmt: Comment) {
        self.comment = cmt
        
        
        User.getUserInfoBy(id: comment.userID) { (usr) in
            self.user = usr

            let cmtText = NSMutableAttributedString(string: self.user.displayName!, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)])
            cmtText.append(NSMutableAttributedString(string: ": \(self.comment.message!)"))
            self.lbl_comment.attributedText = cmtText
            
            Utilites.downloadImage(from: URL(string: self.user.photoURL!)!, id: self.user.uid!, completion: { (image) in
                self.iv_avatar.image = image
            })

        }
//        lbl_comment.attributedText = NSMutableAttributedString(string: cmt.message, attributes: [NSAttributedString.Key.font: 13])
//        User.getUserInfoBy(id: cmt.userID!) { (user) in
//            self.user = user
//
//            var cmt = NSMutableAttributedString(string: user.displayName, attributes: [NSAttributedString.Key.font: 13])
//            cmt.append(NSMutableAttributedString(string: ": \(self.comment.message)"))
//            self.lbl_comment.attributedText = cmt
//
//            Utilites.downloadImage(from: URL(string: user.photoURL)!) { (image) in
//                self.iv_avatar.image = image
//            }
//        }
       
    }

}
