//
//  ViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/17/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserLoggedIn()
    }
    
    func checkIfUserLoggedIn() {
        if let user = Auth.auth().currentUser {
            print("user Loggin")
            logOut()
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView") {
                self.navigationController?.pushViewController(vc, animated: true    )
            }
            
        }else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView") {
                self.navigationController?.pushViewController(vc, animated: true    )
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        }catch {
            print("error: \(error.localizedDescription)")
        }
    }

}

