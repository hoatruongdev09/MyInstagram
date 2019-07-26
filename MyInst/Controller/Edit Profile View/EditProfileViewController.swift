//
//  EditProfileViewController.swift
//  MyInst
//
//  Created by hoatruong on 7/26/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    
    
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_nickname: UITextField!
    @IBOutlet weak var tf_website: UITextField!
    @IBOutlet weak var tf_bio: UITextField!
    
    
    @IBOutlet weak var tf_emailAddress: UITextField!
    @IBOutlet weak var tf_phoneNumber: UITextField!
    @IBOutlet weak var tf_gender: UITextField!
    
    var user: User! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonApplyClicked(_ sender: Any) {
        
    }
    @IBAction func buttonChangePhotoClicked(_ sender: Any) {
    }
}
