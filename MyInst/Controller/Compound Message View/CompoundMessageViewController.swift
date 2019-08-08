//
//  CompoundMessageViewController.swift
//  MyInst
//
//  Created by hoatruong on 8/5/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase

class CompoundMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var tableBoxMessage: UITableView!
    @IBOutlet weak var collectionViewTag: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    
    private var tableData = [[],[]]
    
    private var currentUserBox = Database.database().reference().child("user")
    private var tagUserArray: [(String, String)] = []
    
    private let inset: CGFloat = 2
    private let minimumLineSpacing: CGFloat = 2
    private let minimumInteritemSpacing: CGFloat = 2
    private let cellsPerRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialTableBoxMessage()
        initializeTagUserCollectionView()
    }
    
    /// TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewMessageViewCell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell", for: indexPath) as! NewMessageViewCell
        
        cell.setData(data: tableData[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ticked at: \(indexPath)")
        let cell: NewMessageViewCell = tableView.cellForRow(at: indexPath) as! NewMessageViewCell
        print("cell at \(indexPath): \(cell)")
        cell.setTicked()
        let user = cell.getUser()
        if checkIfTagExist(id: user.uid) {
            print("remove tag: \(user.uid)")
            removeTag(id: user.uid)
        } else {
            print("add tag: \(user.uid)")
            addTag(touple: (user.uid, user.nickName))
        }
        
    }
    
    /// INITIALIZE DATA FOR TABLE VIEW
    private func initialTableBoxMessage() {
        
        tableBoxMessage.delegate = self
        tableBoxMessage.dataSource = self
        
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
                    self.tableBoxMessage.beginUpdates()
                    self.tableData[0].append(user)
                    self.tableBoxMessage.insertRows(at: [IndexPath(row: self.tableData[0].count - 1, section: 0)], with: .none)
                    self.tableBoxMessage.endUpdates()
                }
                
            })
        }
    }
    private func checkIfSuggestionExist(user: User) -> Bool {
        for data in tableData[0] {
            let userData: User = data as! User
            if userData.uid == user.uid {
                return true
            }
        }
        return false
    }
    /// INITIALIZE FOR COLLECTION VIEW
    private func initializeTagUserCollectionView() {
        collectionViewTag.delegate = self
        collectionViewTag.dataSource = self
    }
    
    /// TAG USER COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagUserArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagUserCollectionViewCell = collectionViewTag.dequeueReusableCell(withReuseIdentifier: "tagUser", for: indexPath) as! TagUserCollectionViewCell
        print("cell for item at: \(indexPath.row)")
        cell.lblUserName.text = tagUserArray[indexPath.row].1
        cell.deleteAction = { () -> () in
            self.removeTag(id: self.tagUserArray[indexPath.row].0)
            (self.tableBoxMessage.cellForRow(at: indexPath) as! NewMessageViewCell).setTicked()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("cell for item at: \(indexPath): \(collectionView.cellForItem(at: indexPath))")
        var width: CGFloat = 0
        var height: CGFloat = 0
        if let font = UIFont(name: "Helvetica", size: 24) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let myText = tagUserArray[indexPath.row].1
            let size = (myText as NSString).size(withAttributes: fontAttributes)
            width = size.width
            height = size.height
        }
        return CGSize(width: width, height: height + 5)
    }
    /// tag Clouds VIEW
    private func addTag(touple: (String, String)) {
        tagUserArray.append(touple)
        collectionViewTag.insertItems(at: [IndexPath(row: tagUserArray.count - 1, section: 0)])
        //collectionViewTag.reloadData()
    }
    private func removeTag(id: String) {
        print("toupe before delete: \(tagUserArray)")
        for i in 0...(tagUserArray.count - 1) {
            print("remove tag if i: \(i)")
            if tagUserArray[i].0 == id {
                tagUserArray.remove(at: i)
                collectionViewTag.deleteItems(at: [IndexPath(row: i, section: 0)])
                break
            }
        }
    }
    private func checkIfTagExist(id: String) -> Bool {
        for tag in tagUserArray {
            if tag.0 == id {
                return true
            }
        }
        return false
    }
    
    
    /// BUTTON
    
    @IBAction func buttonChatClicked(_ sender: Any) {
        var member: [String] = [Auth.auth().currentUser!.uid]
        for child in tagUserArray {
            member.append(child.0)
        }
        print("member for create box: \(member)")
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
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
