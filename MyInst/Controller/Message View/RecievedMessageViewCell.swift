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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
