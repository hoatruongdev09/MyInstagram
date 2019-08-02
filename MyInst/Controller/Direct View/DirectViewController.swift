//
//  DirectViewController.swift
//  MyInst
//
//  Created by hoatruong on 7/31/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class DirectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var boxChatTable: UITableView!
    
    private var userBoxRef: DatabaseReference!
    
    
    private var boxChatData = [[],[]]
    private var boxChatDataHeader = ["Messages", "Suggestions"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initilizeBoxChatTable()
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return boxChatDataHeader[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return boxChatData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxChatData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoxMessageViewCell = tableView.dequeueReusableCell(withIdentifier: "boxMessageCell") as! BoxMessageViewCell
        
        cell.setBoxMessage(boxMessage: boxChatData[indexPath.section][indexPath.row] as! BoxMessage)
        //cell.UpdateUI()
        return cell
    }
    
    private func initilizeBoxChatTable() {
        initializeUserBoxRef()
        loadAllBox()
        
        boxChatTable.delegate = self
        boxChatTable.dataSource = self
    }
    private func initializeUserBoxRef() {
        if let user = Auth.auth().currentUser {
            userBoxRef = Database.database().reference().child("user-box").child(user.uid)
        }
    }
    private func loadAllBox() {
        userBoxRef.observe(.childAdded) { (snapshot) in
            Database.database().reference().child("box-message").child(snapshot.key).observeSingleEvent(of: .value, with: { (snap) in
                
                self.boxChatTable.beginUpdates()
                self.boxChatData[0].append(BoxMessage(snapshot: snap))
                self.boxChatTable.insertRows(at: [IndexPath(row: self.boxChatData[0].count - 1, section: 0)], with: .automatic)
                self.boxChatTable.endUpdates()
            })
        }
    }
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
