//
//  NewMessageViewCell.swift
//  MyInst
//
//  Created by hoatruong on 8/5/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class NewMessageViewCell: UITableViewCell, DirectCellProtocol {
    
    
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_nickName: UILabel!
    @IBOutlet weak var iv_tickImage: UIImageView!
    
    private var user: User!
    
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
            self.user = userData
            self.lbl_userName.text = userData.displayName!
            self.lbl_nickName.text = userData.nickName!
            Utilites.downloadImage(from: URL(string: userData.photoURL)!, id: userData.uid) { (image) in
                DispatchQueue.main.async {
                    self.iv_userAvatar.image = image
                }
                
            }
        }
    }
    func setTicked() {
        iv_tickImage.isHidden = !iv_tickImage.isHidden
        print("iv tick image: \(iv_tickImage.isHidden)")
    }
    func getUser() -> User {
        return user
    }
    
    private func commonInit() {
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
        iv_tickImage.isHidden = true;
    }
    
    
}
