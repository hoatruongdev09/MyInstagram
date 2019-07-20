//
//  UploadPhotoViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/18/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class UploadPhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textStatus: UITextField!
    @IBOutlet weak var imagePost: UIImageView!
    
    var image:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textStatus.delegate = self
        textStatus.becomeFirstResponder()
        
        imagePost.image = self.image
    }
    
    @IBAction func buttonShareThisPhoto(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        let post = Post(userUID: currentUser?.uid ?? "", userName: currentUser?.displayName ?? "", caption: textStatus.text ?? "", imageDownloadURL: "")
        post.setImage(image: imagePost.image!)
        post.save()
        if let vc: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabView") {
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        if let vc: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabView") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
