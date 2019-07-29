//
//  FeedsViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/17/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class FeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostViewCell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostViewCell
        
        let post = posts[indexPath.row]
        cell.post = post
        cell.updateUI()
        
        cell.onCommentTap = { () -> () in
            if let cmView: CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentView") as? CommentViewController {
                cmView.postID = post.postID
                cmView.imagePost = cell.iv_postImage.image
                self.present(cmView, animated: true, completion: nil)
            }
        }
        
        cell.onUserTap = { () -> () in
            if cell.post.userUID == Auth.auth().currentUser?.uid {
                self.tabBarController?.selectedIndex = 2
            } else {
                if let vc: OtherUserViewController = self.storyboard?.instantiateViewController(withIdentifier: "otherView") as? OtherUserViewController {
                    vc.userID = cell.post.userUID
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        //cell.loadContent()
        
        return cell
    }
    
    
    func loadData() {
        let ref = Database.database().reference().child("post")
        ref.observe(.childAdded) { (snapshot) in
            //print("post: \(snapshot)")
            DispatchQueue.main.async {
                let newPost = Post(snapshot: snapshot)
                self.posts.insert(newPost, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.feedTableView.beginUpdates()
                self.feedTableView.insertRows(at: [indexPath], with: .top)
                self.feedTableView.endUpdates()
            }
        }
        //self.feedTableView.reloadData()
    }
    

    @IBAction func buttonCamera(_ sender: Any) {
        if let vc: ChoosePhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "choosePhotoViewController") as? ChoosePhotoViewController {
            vc.chooseFromCamera = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
