//
//  ChoosePhotoViewController.swift
//  MyPin
//
//  Created by hoatruong on 7/18/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var imagePicker = UIImagePickerController()
    var image: UIImage!
    var chooseFromCamera = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        if chooseFromCamera {
            openCamera()
        } else {
            openPhotoLibrary()
        }
    }
    
    func openPhotoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: false, completion: nil)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: false, completion: nil)
        } else {
          self.openPhotoLibrary()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.image = info[.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        let vc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "uploadPhotoViewController"))!
        if let view: UploadPhotoViewController = vc as! UploadPhotoViewController {
            view.image = self.image
            self.navigationController?.pushViewController(view, animated: true)
            print("OK")
        }else {
            print("WTFFF")
        }
        
//            vc.imagePost.image = self.image
//
//            self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
