//
//  FeedsViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/17/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

    @IBAction func buttonCamera(_ sender: Any) {
        if let vc: ChoosePhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "choosePhotoViewController") as! ChoosePhotoViewController {
            vc.chooseFromCamera = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
