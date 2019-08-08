//
//  TagUserCollectionViewCell.swift
//  MyInst
//
//  Created by hoatruong on 8/7/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class TagUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    
    var deleteAction = {() -> () in}
     override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    @IBAction func buttonDeleteClicked(_ sender: Any) {
        deleteAction()
    }
}
