//
//  InfoPanelView.swift
//  MyInst
//
//  Created by hoatruong on 7/24/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class InfoPanelView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    
    @IBOutlet weak var lbl_postCount: UILabel!
    @IBOutlet weak var lbl_follower: UILabel!
    @IBOutlet weak var lbl_following: UILabel!

    var user: User! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle.main
        bundle.loadNibNamed("InfoPanelView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        iv_userAvatar.layer.borderWidth = 1
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.borderColor = UIColor.black.cgColor
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
        
        
        
    }
    
    
    func updateUI() {
        if let user = user {
            lbl_userName.text = user.displayName
            print("user photo info panel: \(user.photoURL)")
            Utilites.downloadImage(from: URL(string: user.photoURL)!, id: user.uid!) { (image) in
                self.iv_userAvatar.image = image
            }
            
            user.getAllFollower { (snapshot) in
                self.lbl_follower.text = "\(snapshot.childrenCount)\nFollower"
            }
            user.getAllFollowing { (snapshot) in
                self.lbl_following.text = "\(snapshot.childrenCount)\nFollowing"
            }
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
