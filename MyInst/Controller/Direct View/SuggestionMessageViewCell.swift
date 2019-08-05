//
//  SuggestionMessageViewCell.swift
//  MyInst
//
//  Created by hoatruong on 8/4/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import Firebase

protocol DirectCellProtocol {
    mutating func setData(data: Any)
    
}

class SuggestionMessageViewCell: UITableViewCell, DirectCellProtocol {
    
    
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    
    private var user: User?
    
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
        if let userData: User = data as? User {
            setUser(user: userData)
        }
    }
    
    func setUser(user: User) {
        self.user = user
        lbl_userName.text = user.nickName
        Utilites.downloadImage(from: URL(string: self.user!.photoURL!)!, id: self.user!.uid!) { (image) in
            DispatchQueue.main.async {
                self.iv_userAvatar.image = image
                print("download image: \(image)")
            }
            
        }
    }
    
    private func commonInit() {
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
        iv_userAvatar.isHidden = true;
    }
}
