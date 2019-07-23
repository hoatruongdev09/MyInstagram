//
//  Utilites.swift
//  MyInst
//
//  Created by hoatruong on 7/23/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import UIKit

class Utilites {
    
    
    static func downloadImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        print("Download Started \(url.absoluteString)")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error download image: \(error?.localizedDescription)")
                return
                
            }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                completion(UIImage(data: data)!)
                //                self.iv_postImage.image = UIImage(data: data)
            }
        }
    }
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
