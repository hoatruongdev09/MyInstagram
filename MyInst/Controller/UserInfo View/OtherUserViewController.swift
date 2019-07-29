//
//  OtherUserViewController.swift
//  MyInst
//
//  Created by hoatruong on 7/27/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class OtherUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    @IBOutlet weak var view_info: InfoPanelView!
    
    @IBOutlet weak var btn_backButton: UIButton!
    
    @IBOutlet weak var postCollection: UICollectionView!
    
    @IBOutlet weak var btn_follow: UIButton!
    var userID: String! = ""
    
    let inset: CGFloat = 5
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    let cellsPerRow = 3
    
    private var user: User! = nil
    
    var posts: [Post] = []
    private var isFollowed: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        loadAllPostOfUser(userID: userID!)
        
        postCollection.delegate = self
        postCollection.dataSource = self
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionViewCell
        cell.post = posts[indexPath.row]
        cell.updateUI()
        
        return cell
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func loadData() {
        User.getUserInfoBy(id: userID) { (user) in
            self.user = user
            //print("user id:    \(self.user.uid)")
            self.view_info.user = self.user!
            self.view_info.updateUI()
            self.btn_backButton.setTitle("   \(user.nickName!)", for: .normal)
            User.checkIfHadFollowedUser(id: Auth.auth().currentUser!.uid, followerID: user.uid, completion: { (yes) in
                self.isFollowed = yes
                if yes {
                    self.btn_follow.setTitle("Following", for: .normal)
                } else {
                    self.btn_follow.setTitle("Following", for: .normal)
                }
            })
            print("other user nick name: \(self.btn_backButton.titleLabel?.text)")
            
            
        }
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
    @IBAction func buttonFollowClicked(_ sender: Any) {
        print("start follow")
        if isFollowed {
            print("user had followed already")
        } else {
            User.followUser(id: Auth.auth().currentUser!.uid, followerID: userID) {
                print("followed")
            }
        }
        
    }
    
    @IBAction func buttonMessageClicked(_ sender: Any) {
        var members: [String] = []
        members.append(Auth.auth().currentUser!.uid)
        members.append(userID!)
        var room = Room(roomID: "", lastMessageID: "", members: members)
        room.createRoom()
        if let vc: MessageViewController = self.storyboard?.instantiateViewController(withIdentifier: "messageView") as? MessageViewController{
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
