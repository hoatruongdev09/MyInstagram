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
    
    @IBOutlet weak var view_infoView: MessengerInfoView!
    @IBOutlet weak var bottomInputConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tb_chatLog: UITableView!
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var tf_chatInput: UITextField!
    
    var messageBoxID: String = ""
    
    
    var boxMessage: BoxMessage!
    var currentUser: User!
    
    private var messageRef: DatabaseReference!
    private var boxMessageRef: DatabaseReference!
    private var messages: [Message] = []
    private var members: [String:User] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        messageTable.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        //        initializeCurrentUser()
        //        loadMessages()
        initializeAllBoxMessage()
        
        messageTable.delegate = self
        messageTable.dataSource = self
        
        
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
        let msg = messages[indexPath.row]
        if msg.fromID == currentUser.uid {
            let cell: SenderMessageViewCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderMessageViewCell
            cell.setMessage(msg: msg)
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        let cell: RecievedMessageViewCell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as! RecievedMessageViewCell
        cell.setMessage(msg: msg)
        cell.setUser(usr: members[msg.fromID]!)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
        
        
    }
    
    
    func initializeCurrentUser() {
        if let usr = Auth.auth().currentUser {
            User.getUserInfoBy(id: usr.uid) { (user) in
                self.currentUser = user
            }
        }
    }
    
    func loadBoxMessage(completion: @escaping () -> Void) {
        boxMessageRef = Database.database().reference().child("box-message").child(messageBoxID)
        
        boxMessageRef.observe(.value) { (snapshot) in
            self.boxMessage = BoxMessage(snapshot: snapshot)
            print("box member: \(self.boxMessage.members)")
            completion()
        }
    }
    func loadAllUserInBoxMessage(completion: @escaping () -> Void) {
        print("loadAllUserInBoxMessage: \(self.currentUser)")
        let currentUserID = Auth.auth().currentUser?.uid
        for userID in self.boxMessage.members {
            if userID == currentUserID {
                continue
            } else {
                User.getUserInfoBy(id: userID) { (tempUser) in
                    self.members[tempUser.uid] = tempUser
                    completion()
                }
            }
        }
        
    }
    
    func initializeAllBoxMessage() {
        self.initializeCurrentUser()
        self.loadBoxMessage {
            self.loadAllUserInBoxMessage {
                self.view_infoView.members = self.members
                self.view_infoView.updateUI()
                self.view_infoView.backButtonEvent = { () -> () in
                    self.dismiss(animated: true, completion: nil)
                }
            }
            self.loadMessages()
        }
        
    }
    
    func loadMessages() {
        print("load all message from: \(messageBoxID)")
        messageRef = Database.database().reference().child("message").child(messageBoxID)
        
        messageRef.observe(.childAdded) { (snapshot) in
            //print("message: \(snapshot)")
            let msg = Message(snapshot: snapshot)
            self.messages.insert(msg, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.messageTable.beginUpdates()
            self.messageTable.insertRows(at: [indexPath], with: .bottom)
            self.messageTable.endUpdates()
        }
    }
    
    
    @IBAction func buttonSendClick(_ sender: Any) {
        sendMessage()
    }
    
    func sendMessage() {
        if tf_chatInput.text!.isEmpty {
            return
        }
        let content = tf_chatInput.text
        let from = currentUser.uid
        let boxID = messageBoxID
        
        var message = Message(boxID: boxID, fromID: from!, content: content!)
        message.sendMessage()
        tf_chatInput.text = ""
    }
}
