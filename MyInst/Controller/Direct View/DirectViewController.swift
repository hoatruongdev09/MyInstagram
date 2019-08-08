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
    @IBOutlet weak var tf_search: UITextField!
    
    private var userBoxRef: DatabaseReference!
    private var currentUserBox = Database.database().reference().child("user")
    
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
        var cellProtocol: DirectCellProtocol? = nil
        if boxChatDataHeader[indexPath.section] == "Messages" {
            let cell: BoxMessageViewCell = tableView.dequeueReusableCell(withIdentifier: "boxMessageCell") as! BoxMessageViewCell
            cell.setData(data: boxChatData[indexPath.section][indexPath.row] as! BoxMessage)
            cellProtocol = cell
        } else if boxChatDataHeader[indexPath.section] == "Suggestions" {
            let cell: SuggestionMessageViewCell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell") as! SuggestionMessageViewCell
            cell.setData(data: boxChatData[indexPath.section][indexPath.row] as! User)
            cellProtocol = cell
        }
        
        //cell.UpdateUI()
        return cellProtocol as! UITableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if boxChatDataHeader[indexPath.section] == "Messages" {
            let boxMessage = boxChatData[indexPath.section][indexPath.row] as! BoxMessage
            if let vc: MessageViewController = self.storyboard?.instantiateViewController(withIdentifier: "messageView") as? MessageViewController{
                vc.messageBoxID = boxMessage.boxID
                self.present(vc, animated: true, completion: nil)
            }
        } else if boxChatDataHeader[indexPath.section] == "Suggestions" {
            let user = boxChatData[indexPath.section][indexPath.row] as! User
            let member = [Auth.auth().currentUser!.uid, user.uid!]
            let box = BoxMessage(members: member)
            //        box.createBox()
            box.createBox { (boxID) in
                print("create a new box message with id: \(boxID)")
                
                if let vc: MessageViewController = self.storyboard?.instantiateViewController(withIdentifier: "messageView") as? MessageViewController{
                    vc.messageBoxID = boxID
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    private func initilizeBoxChatTable() {
        initializeUserBoxRef()
        loadAllBox()
        loadAllSuggestion()
        
        boxChatTable.delegate = self
        boxChatTable.dataSource = self
    }
    private func initializeUserBoxRef() {
        if let user = Auth.auth().currentUser {
            userBoxRef = Database.database().reference().child("box-user").child(user.uid)
        }
    }
    private func loadAllBox() {
        userBoxRef.observe(.childAdded) { (snapshot) in
            Database.database().reference().child("box-message").child(snapshot.key).observeSingleEvent(of: .value, with: { (snap) in
                
                self.boxChatTable.beginUpdates()
                self.boxChatData[0].append(BoxMessage(snapshot: snap))
                self.boxChatTable.insertRows(at: [IndexPath(row: self.boxChatData[0].count - 1, section: 0)], with: .none)
                self.boxChatTable.endUpdates()
            })
        }
    }
    private func loadAllSuggestion() {
        
        loadAllFollower(type: "follower")
        loadAllFollower(type: "following")
    }
    
    private func loadAllFollower(type: String) {
        let followerRef = currentUserBox.child(Auth.auth().currentUser!.uid).child(type)
        followerRef.observe(.childAdded) { (snapShot) in
            let userRef = Database.database().reference().child("user").child(snapShot.key)
            userRef.observeSingleEvent(of: .value, with: { (data) in
                let user = User(snapshot: data)
                if !self.checkIfSuggestionExist(user: user) {
                    self.boxChatTable.beginUpdates()
                    self.boxChatData[1].append(user)
                    self.boxChatTable.insertRows(at: [IndexPath(row: self.boxChatData[1].count - 1, section: 1)], with: .none)
                    self.boxChatTable.endUpdates()
                }
                
            })
        }
    }
    
    private func checkIfSuggestionExist(user: User) -> Bool {
        for data in boxChatData[1] {
            let userData: User = data as! User
            if userData.uid == user.uid {
                return true
            }
        }
        return false
    }
   
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonCompoundMessageClicked(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "compoundMessage") {
            present(vc, animated: true, completion: nil)
        }
    }
    
}
