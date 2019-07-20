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



class LoginViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageSlide: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var orLabel: UILabel!
    
    var imageSource = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6")]
    
    
    var timer = Timer()
    var counter = 0
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
        
        //let signInWithFacebook = FBLoginButton()
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: signInWithFacebook, attribute: .top, relatedBy: .equal, toItem: orLabel, attribute: .bottom, multiplier: 1, constant: 20),
//            NSLayoutConstraint(item: signInWithFacebook, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: signInWithFacebook, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.6, constant: view.bounds.width)
//            ])
        
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
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabView") {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
