//
//  Utilites.swift
//  MyInst
//
//  Created by hoatruong on 7/23/19.
//  Copyright © 2019 hoatruong. All rights reserved.
//

import Foundation
import UIKit

class Utilites {
    
    
    public static func downloadImage(from url: URL, id: String, completion: @escaping (_ image: UIImage) -> Void) {
        print("Download Started \(url.absoluteString)")
        
        if checkFileExisted(fileName: id) {
            getData(from: self.fileURLInDocumentDirectory(id)) { (data, res, err) in
                if let err = err {
                    print("error get file: \(err.localizedDescription)")
                } else {
                    if let dImage = UIImage(data: data!) {
                        completion(dImage)
                        return
                    }
                }
            }
        } else {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("error download image: \(error?.localizedDescription)")
                    return
                    
                }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                        self.storeImageToDocumentDirectory(image: downloadedImage, fileName: id)
                    } else {
                        print("error cannot download image")
                        completion(UIImage(named: "temp_im")!)
                        return
                    }
                    //                self.iv_postImage.image = UIImage(data: data)
                }
            }
        }
        
        getData(from: self.fileURLInDocumentDirectory(id)) { (data, res, err) in
            guard let data = data, err == nil else {
                print("there is no file for \(id), error: \(err?.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    print(("load from local"))
                    completion(downloadedImage)
                    return
                } else {
                    print("error cannot get local image")
                    getData(from: url) { data, response, error in
                        guard let data = data, error == nil else {
                            print("error download image: \(error?.localizedDescription)")
                            return
                            
                        }
                        print(response?.suggestedFilename ?? url.lastPathComponent)
                        print("Download Finished")
                        DispatchQueue.main.async() {
                            if let downloadedImage = UIImage(data: data) {
                                completion(downloadedImage)
                                self.storeImageToDocumentDirectory(image: downloadedImage, fileName: id)
                            } else {
                                print("error cannot download image")
                                completion(UIImage(named: "temp_im")!)
                            }
                            //                self.iv_postImage.image = UIImage(data: data)
                        }
                    }

                }
            }
        }
        
    }
    public static func checkFileExisted(fileName: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func storeImageToDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        let fileURL = self.fileURLInDocumentDirectory(fileName)
        do {
            try data.write(to: fileURL)
            print("saved in local")
            return fileURL
        } catch {
            return nil
        }
    }
    public static var documentsDirectoryURL: URL {
        return FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
    }
    public static func fileURLInDocumentDirectory(_ fileName: String) -> URL {
        return self.documentsDirectoryURL.appendingPathComponent(fileName)
    }

}
