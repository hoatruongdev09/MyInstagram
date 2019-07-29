//
//  MessageViewController.swift
//  MyInst
//
//  Created by hoatruong on 7/28/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bottomInputConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tb_chatLog: UITableView!
    @IBOutlet weak var messageTable: UITableView!
    
    var messages = [] 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let offset = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.bottomInputConstraint.constant = offset.height
            }
        }
    }
    @objc func keyboardWillHide(_ sender: NSNotification) {
        print("keyboar will hide")
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
            self.bottomInputConstraint.constant = 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    

}
