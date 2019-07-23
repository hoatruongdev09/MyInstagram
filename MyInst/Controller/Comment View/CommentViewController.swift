//
//  CommentViewController.swift
//  MyInst
//
//  Created by hoatruong on 7/22/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase
class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableOfComment: UITableView!
    
    @IBOutlet weak var iv_userAvatar: UIImageView!
    @IBOutlet weak var tf_comment: UITextField!
    
    @IBOutlet weak var viewInput: UIView!
    
    var postID: String! = ""
    var comments: [Comment] = []
    var user: User! = nil
    
    var viewInputY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableOfComment.delegate = self
        tableOfComment.dataSource = self
        
        viewInputY = viewInput.frame.origin.y
        
        loadData()
        iniViewInput()
    }
    
    func iniViewInput() {
        if let curUser = Auth.auth().currentUser {
            User.getUserInfoBy(id: curUser.uid) { (user) in
                self.user = user
                
                Utilites.downloadImage(from: URL(string: self.user.photoURL!)!, completion: { (image) in
                    self.iv_userAvatar.image = image
                })
            }
        }
        iv_userAvatar.layer.borderWidth = 1
        iv_userAvatar.layer.masksToBounds = false
        iv_userAvatar.layer.borderColor = UIColor.black.cgColor
        iv_userAvatar.layer.cornerRadius = iv_userAvatar.frame.height/2
        iv_userAvatar.clipsToBounds = true
        
       // tf_comment.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    @objc func keyboardWillShow(_ sender: NSNotification) {
        let userInfo = sender.userInfo!
        
        let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        
        let offset = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        print("pos view input: \(viewInput.frame.origin.y)")
        print("viewInputY: \(viewInputY)")
        print("keyboard height: \(keyboardSize.height)")
        print("offset: \(offset.height)")
        
        if keyboardSize.height == offset.height {
            print("wtf")
            if viewInput.frame.origin.y <= viewInputY {
                print("ok do animation")
                UIView.animate(withDuration: 0.15) {
                    self.viewInput.frame.origin.y -= keyboardSize.height
                }
            }
        }else{
            UIView.animate(withDuration: 0.15) {
                self.viewInput.frame.origin.y += keyboardSize.height - offset.height
            }
        }
 
    }
    @objc func keyboardWillHide(_ sender: NSNotification) {
        let userInfo = sender.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        self.viewInput.frame.origin.y += keyboardSize.height
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonPost(_ sender: Any) {
        let message = tf_comment.text
        let userID = self.user.uid
        let postID = self.postID
        
        if message?.count != 0 {
            let comment: Comment = Comment(postID: postID!, userID: userID!, message: message!)
            comment.save()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        cell.setComment(comments[indexPath.row])
        
        return cell
    }
    
    func loadData() {
        let cmtRef = Database.database().reference().child("comments").child(postID)
        
        cmtRef.observe(.childAdded) { (snapshot) in
            print("comment: \(snapshot)")
            DispatchQueue.main.async {
                let newPost = Comment(snapshot: snapshot)
                self.comments.insert(newPost, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableOfComment.insertRows(at: [indexPath], with: .top)
            }

        }
        
    }
    
}
