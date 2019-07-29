//
//  UserViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/17/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var view_info: InfoPanelView!
    @IBOutlet weak var lbl_nickName: UILabel!
    @IBOutlet weak var postCollection: UICollectionView!
    
    @IBOutlet weak var view_optionPanel: UIView!
    @IBOutlet weak var slideOptionPanel_trailConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btn_signOut: UIButton!
    
    
    var userID: String! = ""
    
    let inset: CGFloat = 5
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    let cellsPerRow = 3
    
    private var user: User! = nil
    private var isShowOption = false
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            loadData()
            
            loadAllPostOfUser(userID: userID)
            
            
        }
        
        postCollection.delegate = self
        postCollection.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let optionPanelWidth = view_optionPanel.bounds.width
        slideOptionPanel_trailConstraint.constant = -optionPanelWidth
        
    }
    
    func loadData() {
        User.getUserInfoBy(id: userID) { (user) in
            self.user = user
            //print("user id:    \(self.user.uid)")
            self.view_info.user = self.user!
            self.view_info.updateUI()
            
            self.lbl_nickName.text = self.user.nickName
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cmView: CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentView") as? CommentViewController {
            if let cell: PostCollectionViewCell = postCollection.cellForItem(at: indexPath) as? PostCollectionViewCell {
                cmView.postID = cell.post.postID
                cmView.imagePost = cell.iv_postContent.image
                self.present(cmView, animated: true, completion: nil)
            }
           
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("posts count: \(posts.count)")
        return posts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionViewCell
        cell.post = posts[indexPath.row]
        cell.updateUI()

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    func loadAllPostOfUser(userID: String) {
        let postRef = Database.database().reference().child("post").queryOrdered(byChild: "userUID").queryEqual(toValue: userID)
        postRef.observe(.value) { (snapshot) in
            
            self.view_info.lbl_postCount.text = "\(snapshot.childrenCount)\nPosts"
        }
        postRef.observe(.childAdded) { (snapshot) in
            let post = Post(snapshot: snapshot)
            print("post: \(post.imageDownloadURL!)")
            self.posts.insert(post, at: 0)
            
            self.postCollection.reloadData()
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    @IBAction func buttonOptionClicked(_ sender: Any) {
        if isShowOption {
            animateHideOptionPanel()
            isShowOption = false
        } else {
            animateShowOptionPanel()
            isShowOption = true
        }
    }
    @IBAction func buttonSingOutClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
        } catch {
            print("error sign out: \(error.localizedDescription)")
            return
        }
        
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    func animateHideOptionPanel() {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            //self.slideOptionPanel_trailConstraint.constant = -optionPanelWidth
            self.view_optionPanel.frame.origin.x = self.view.bounds.width
            
        }, completion: nil)
    }
    func animateShowOptionPanel() {
        let optionPanelWidth = view_optionPanel.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            //self.slideOptionPanel_trailConstraint.constant = 0
            self.view_optionPanel.frame.origin.x = self.view.bounds.width - optionPanelWidth
        }, completion: nil)

    }
    @IBAction func buttonEditProfileClicked(_ sender: Any) {
        if let vc: EditProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "editProfileView") as? EditProfileViewController {
            vc.user = self.user
            self.present(vc, animated: true, completion: nil)
        }
    }
}
