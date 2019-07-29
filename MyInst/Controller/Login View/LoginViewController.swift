//
//  LoginViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/17/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class LoginViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LoginButtonDelegate {
    
    
    
    @IBOutlet weak var imageSlide: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    var imageSource = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6")]
    
    
    var timer = Timer()
    var counter = 0
    let defaulAvatarURL = "https://firebasestorage.googleapis.com/v0/b/mypin-3be7c.appspot.com/o/default%2Fuser%20(1).png?alt=media&token=1e8fc068-27e4-4472-9db8-ac43ad6be33f"
    let signInWithFacebook = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageSlide.delegate = self
        imageSlide.dataSource = self
        
        pageView.numberOfPages = imageSource.count
        pageView.currentPage = 0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            
        }
        
        signInWithFacebookInit()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }


    @IBAction func buttonLoginAnonymously(_ sender: Any) {
        self.authenticateAnonymously()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SlideImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideImageCell", for: indexPath) as! SlideImageCell
        cell.image.image = imageSource[indexPath.row]
        pageView.currentPage = indexPath.row
        //print("index path row: \(indexPath.row)")
        //print("current page: \(pageView.currentPage)")
        return cell
    }
    
    func signInWithFacebookInit() {
        
        signInWithFacebook.delegate = self
        
        signInWithFacebook.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInWithFacebook)
        NSLayoutConstraint.activate([
            signInWithFacebook.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 30),
            signInWithFacebook.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            signInWithFacebook.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            signInWithFacebook.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("login facebook error: \(error.localizedDescription)")
            return
        }
        if let result = result {
            if result.isCancelled {
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("login facebook error firebase: \(error.localizedDescription)")
                    return
                }
                
                if let authedUser = result?.user {
                    self.checkIfUserExisted(authedUser.uid, completion: { (existed) in
                        if existed {
                            print("user existed")
                        } else {
                            let user: User = User(uid: authedUser.uid, displayName: authedUser.displayName ?? "Anonumous", nickName: authedUser.displayName ?? "Anonumous", website: "", bio: "", gender: "Not Show", photoURL: authedUser.photoURL?.absoluteString ?? self.defaulAvatarURL, email: authedUser.email ?? "", phone: authedUser.phoneNumber ?? "")
//                            var user: User = User(uid: authedUser.uid, displayName: authedUser.displayName ?? "Anonymouse", photoURL: authedUser.photoURL?.absoluteString ?? self.defaulAvatarURL, email: authedUser.email ?? "", phone: authedUser.phoneNumber ?? "")
                            user.save()
                        }
                    })
                    
                }
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabView") {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
      
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                print("sign out facebook error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func changeImage() {
        counter += 1
        if counter >= imageSource.count {
            counter = 0
        }
        let index = IndexPath(item: counter, section: 0)
        self.imageSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    private func authenticateAnonymously() {
        Auth.auth().signInAnonymously { (result, error) in
            if let err = error {
                print("anonym auth error: \(err.localizedDescription)")
            }else{
                let authedUser = Auth.auth().currentUser
                if let authedUser = authedUser {
                    self.checkIfUserExisted(authedUser.uid, completion: { (existed) in
                        if existed {
                            print("user existed")
                        } else {
                           let user: User = User(uid: authedUser.uid, displayName: authedUser.displayName ?? "Anonumous", nickName: authedUser.displayName ?? "Anonumous", website: "", bio: "", gender: "Not Show", photoURL: authedUser.photoURL?.absoluteString ?? self.defaulAvatarURL, email: authedUser.email ?? "", phone: authedUser.phoneNumber ?? "")
                            user.save()
                        }
                    })
                    
                }
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabView") {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func checkIfUserExisted (_ uid: String, completion: @escaping (_ existed: Bool) -> Void) {
        let ref = Database.database().reference().child("user")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.hasChild(uid))
        }
    }
}
