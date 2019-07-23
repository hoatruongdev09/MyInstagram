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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostViewCell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostViewCell
        
        let post = posts[indexPath.row]
        cell.post = post
        cell.updateUI()
        
        cell.onCommentTap = { () -> () in
            if let cmView: CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentView") as! CommentViewController {
                cmView.postID = post.postID
                self.present(cmView, animated: true, completion: nil)
            }
        }
        //cell.loadContent()
        
        return cell
    }
    
    
    func loadData() {
        let ref = Database.database().reference().child("post")
        ref.observe(.childAdded) { (snapshot) in
            print("post: \(snapshot)")
            DispatchQueue.main.async {
                let newPost = Post(snapshot: snapshot)
                self.posts.insert(newPost, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.feedTableView.insertRows(at: [indexPath], with: .top)
            }
        }
    }
    

    @IBAction func buttonCamera(_ sender: Any) {
        if let vc: ChoosePhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "choosePhotoViewController") as! ChoosePhotoViewController {
            vc.chooseFromCamera = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
