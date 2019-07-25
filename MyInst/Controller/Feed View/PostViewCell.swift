//
//  PostViewCell.swift
//  MyInst
//
//  Created by hoatruong on 7/20/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class PostViewCell: UITableViewCell {
    
    var post: Post!
    
    var onCommentTap = { () -> () in}
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var iv_postImage: UIImageView!
    @IBOutlet weak var tv_caption: UILabel!
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCommentTapped(sender:)))
        tv_caption.isUserInteractionEnabled = true
        tv_caption.addGestureRecognizer(tap)
        
        iv_userAvatar.layer.borderWidth = 1
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.borderColor = UIColor.black.cgColor
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
    }
    
    
    func updateUI() {
        
        var captionString = NSMutableAttributedString(string: post.userName!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)])
        captionString.append(NSMutableAttributedString(string: ": \(post.caption!)"))
        
        self.tv_caption.attributedText = captionString
        self.lbl_userName.text = post.userName
        
//        if let imageDownloadUrl = post.imageDownloadURL {
//            Utilites.downloadImage(from: URL(string: imageDownloadUrl)!, id: post.postID!) { (image) in
////                self.iv_postImage.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//                DispatchQueue.main.async {
//                    self.iv_postImage.image = image
//                }
//
//            }
//        }
        DispatchQueue.main.async {
            self.iv_postImage.image = self.post.getImage()
        }
        if let usr: User = CacheUser.checkAndGetUser(id: post.userUID){
            self.iv_userAvatar.image = usr.imagePhoto

        } else {
            downloadUserAvatar(id: post.userUID)
        }
        
    }
    func updateUI2() {
        
        let captionString = NSMutableAttributedString(string: post.userName!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)])
        captionString.append(NSMutableAttributedString(string: ": \(post.caption!)"))
        
        self.tv_caption.attributedText = captionString
        self.lbl_userName.text = post.userName
        
        post.imageSetEvent = {() -> () in
            DispatchQueue.main.async {
                self.iv_postImage.image = self.post.getImage()
            }
            
        }
        
        
        if let usr: User = CacheUser.checkAndGetUser(id: post.userUID){
            self.iv_userAvatar.image = usr.imagePhoto
            
        } else {
            downloadUserAvatar(id: post.userUID)
        }
        
    }
    
    
    private func downloadUserAvatar(id: String) {
        User.getUserInfoBy(id: id) { (user) in
            Utilites.downloadImage(from: URL(string: user.photoURL)!, id: id, completion: { (image) in
                self.iv_userAvatar.image = image
                user.imagePhoto = image
                CacheUser.addToCache(usr: user)
            })
        }
    }
    
    @objc func onCommentTapped(sender: UITapGestureRecognizer) {
        onCommentTap()
    }
}
