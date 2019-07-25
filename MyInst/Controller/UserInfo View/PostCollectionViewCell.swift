//
//  PostCollectionViewCell.swift
//  MyInst
//
//  Created by hoatruong on 7/24/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var iv_postContent: UIImageView!
    
    var post: Post! = nil
    
    func updateUI() {
        print("cell post: \(post.postID!)")
        if let post = self.post {
            Utilites.downloadImage(from: URL(string: post.imageDownloadURL!)!, id: post.postID!) { (image) in
                self.iv_postContent.image = image
                print("collection cell download: \(image)")
            }
        }
    }
    
}
