//
//  NewMessageViewCell.swift
//  MyInst
//
//  Created by hoatruong on 8/5/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class NewMessageViewCell: UITableViewCell {
    @IBOutlet weak var iv_userAvatar: UIView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_nickName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
