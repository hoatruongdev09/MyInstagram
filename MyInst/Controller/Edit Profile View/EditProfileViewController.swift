//
//  EditProfileViewController.swift
//  MyInst
//
//  Created by hoatruong on 7/26/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var embededProfileTable: UIView!
    
    var profileTable: ProfileTableViewController?
    
    var user: User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileTable = self.children[0] as? ProfileTableViewController
        
        
        if let user = self.user {
            print("user: \(user.uid)")
            profileTable?.tf_name.text = user.displayName!
            profileTable?.tf_bio.text = user.bio
            profileTable?.tf_email.text = user.email
            profileTable?.tf_nickname.text = user.nickName
            profileTable?.tf_gender.text = user.gender
            profileTable?.tf_website.text = user.website
            profileTable?.tf_phoneNum.text = user.phone
            
            Utilites.downloadImage(from: URL(string: user.photoURL!)!, id: user.uid!) { (image) in
                DispatchQueue.main.async {
                    self.profileTable?.iv_userAvatar.image = image
                }
                
            }
            if self.profileTable != nil {
                print("OKKKKK")
            } else {
                print("DEO OOOO")
            }
        }
    }

    @IBAction func buttonCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonApplyClicked(_ sender: Any) {
        let changed = getAllChange()
        
        self.user?.bio = changed["bio"] ?? ""
        self.user?.displayName = changed["displayName"] ?? ""
        self.user?.email = changed["email"] ?? ""
        self.user?.gender = changed["gender"] ?? ""
        self.user?.nickName = changed["nickName"] ?? ""
        self.user?.phone = changed["phone"] ?? ""
        self.user?.website = changed["website"] ?? ""
        
        user?.save()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func buttonChangePhotoClicked(_ sender: Any) {
    }
    
    func getAllChange() -> [String: String?] {
        let dict = [
            "displayName": self.profileTable?.tf_name?.text,
            "bio": self.profileTable?.tf_bio?.text,
            "email": self.profileTable?.tf_email?.text,
            "gender": self.profileTable?.tf_gender?.text,
            "nickName": self.profileTable?.tf_nickname?.text,
            "phone": self.profileTable?.tf_phoneNum?.text,
            "website": self.profileTable?.tf_website?.text
        ]
        
        return dict
    }
}
