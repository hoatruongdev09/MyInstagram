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
    var onUserTap = {() -> () in}
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var iv_postImage: UIImageView!
    @IBOutlet weak var tv_caption: UILabel!
    
    @IBOutlet weak var buttonLike: UIButton!
    
    private var userLiked: Bool = false
    
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
        let userTap = UITapGestureRecognizer(target: self, action: #selector(onUserTap(sender:)))
        
        tv_caption.isUserInteractionEnabled = true
        tv_caption.addGestureRecognizer(tap)
        
        iv_userAvatar.isUserInteractionEnabled = true
        iv_userAvatar.addGestureRecognizer(userTap)
        
        iv_userAvatar.layer.borderWidth = 1
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.borderColor = UIColor.black.cgColor
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
    }
    
    
    func updateUI() {
        
        let captionString = NSMutableAttributedString(string: post.userName!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11)])
        captionString.append(NSMutableAttributedString(string: ": \(post.caption!)"))
        
        self.tv_caption.attributedText = captionString
        self.lbl_userName.text = post.userName
        
        if self.post.getImage() != nil {
            self.iv_postImage.image = self.post.getImage()
        } else {
            Utilites.downloadImage(from: URL(string: self.post.imageDownloadURL!)!, id: self.post.postID) { (image) in
                DispatchQueue.main.async {
                    self.iv_postImage.image = image
                }
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.iv_postImage.image = self.post.getImage()
        }
        if let usr: User = CacheUser.checkAndGetUser(id: post.userUID){
            self.iv_userAvatar.image = usr.imagePhoto

        } else {
            downloadUserAvatar(id: post.userUID)
        }
        self.post.getAllLiker {
            if self.post.checkIfUserLiked(userID: Auth.auth().currentUser!.uid) {
                self.buttonLike.imageView?.image = UIImage(named: "like_clicked")
                self.userLiked = true
            } else {
                self.buttonLike.imageView?.image = UIImage(named: "like")
                self.userLiked = false
            }
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
                DispatchQueue.main.async {
                    self.iv_userAvatar.image = image
                }
                user.imagePhoto = image
                CacheUser.addToCache(usr: user)
            })
        }
    }
    
    @objc func onCommentTapped(sender: UITapGestureRecognizer) {
        onCommentTap()
    }
    @objc func onUserTap(sender: UITapGestureRecognizer) {
        onUserTap()
    }
    
    @IBAction func buttonLikeClicked(_ sender: Any) {
        if userLiked {
            self.post.removeLiker(userID: Auth.auth().currentUser!.uid)
            userLiked = false
        } else {
            self.post.addLiker(userID: Auth.auth().currentUser!.uid)
            userLiked = true
        }
        
    }
    @IBAction func buttonMessageClicked(_ sender: Any) {
        onCommentTap()
    }
}
