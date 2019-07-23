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
        
        if let currentUser = Auth.auth().currentUser {
            let post: Post = Post(userUID: currentUser.uid, userName: currentUser.displayName ?? "Anonymouse", caption: textStatus.text!, imageDownloadURL: "", postID: "")
            post.setImage(image: imagePost.image!)
            post.save()
            
            let cmt: Comment = Comment(postID: post.postID!, userID: currentUser.uid, message: post.caption!)
            cmt.save()
        }
       
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
