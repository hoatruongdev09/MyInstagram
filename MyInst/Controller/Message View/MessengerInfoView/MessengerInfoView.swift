//
//  MessengerInfo.swift
//  MyInst
//
//  Created by hoatruong on 7/28/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class MessengerInfoView: UIView {

    
    @IBOutlet var iv_allUserAvatar: [UIImageView]!
    
    
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_lastOnline: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    var members: [String: User] = [:]
    
    var backButtonEvent = { () -> () in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    
    private func commonInit() {
        let bundle = Bundle.main
        bundle.loadNibNamed("MessengerInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.bounds = self.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        for imageView in iv_allUserAvatar {
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
        }
    
    }
    
    func updateUI() {
        
        if self.members.count != 0 {
            var index = 0
            for user in members {
                if index == 0 {
                    lbl_userName.text = user.value.nickName
                } else {
                    lbl_userName.text?.append(contentsOf: ", \(user.value.nickName)")
                }
                if let tmp: User = CacheUser.checkAndGetUser(id: user.key) {
                    self.iv_allUserAvatar![index].image = tmp.imagePhoto
                } else {
                    Utilites.downloadImage(from: URL(string: user.value.photoURL!)!, id: user.key) { (image) in
                        self.iv_allUserAvatar![index].image = image
                    }
                }
                index += 1
            }
        }
        for index in (self.members.count)...(self.iv_allUserAvatar.count - 1) {
            self.iv_allUserAvatar[index].isHidden = true
        }
    }
    
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        backButtonEvent()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
