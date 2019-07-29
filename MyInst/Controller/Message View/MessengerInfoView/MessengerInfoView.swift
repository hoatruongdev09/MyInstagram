//
//  MessengerInfo.swift
//  MyInst
//
//  Created by hoatruong on 7/28/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class MessengerInfoView: UIView {
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_lastOnline: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    var backButtonEvent = { () -> () in}
    
    var user: User!
    
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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        iv_userAvatar.layer.borderWidth = 1
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.borderColor = UIColor.black.cgColor
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
    
    }
    
    func updateUI() {
        if self.user != nil {
            iv_userAvatar.image = user.imagePhoto
            lbl_userName.text = user.nickName
            
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
