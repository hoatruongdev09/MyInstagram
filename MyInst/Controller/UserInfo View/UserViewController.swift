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
        let postRef = Database.database().reference().child("post")
        postRef.queryOrdered(byChild: "userUID").queryEqual(toValue: userID).observe(.childAdded) { (snapshot) in
            let post = Post(snapshot: snapshot)
            print("post: \(post.imageDownloadURL!)")
            self.posts.insert(post, at: 0)
            self.view_info.lbl_postCount.text = "\(self.posts.count)\nPosts"

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
            if let vc: ViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewController") as! ViewController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } catch {
            print("error sign out: \(error.localizedDescription)")
        }
    }
    
    func animateHideOptionPanel() {
        let optionPanelWidth = view_optionPanel.bounds.width
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            //self.slideOptionPanel_trailConstraint.constant = -optionPanelWidth
            self.view_optionPanel.frame.origin.x = self.view.bounds.width - optionPanelWidth
            
        }, completion: nil)
    }
    func animateShowOptionPanel() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            //self.slideOptionPanel_trailConstraint.constant = 0
            self.view_optionPanel.frame.origin.x = self.view.bounds.width
        }, completion: nil)

    }
}
