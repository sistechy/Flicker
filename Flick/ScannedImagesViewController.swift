//
//  ScannedImagesViewController.swift
//  Flick
//
//  Created by Vidhya C on 26/07/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
class ScannedImagesViewController: UIViewController {
 static var selectedName = String()
 let storage = Storage.storage()
    var image = UIImage()
    var selectedFolderName: String?
    var imagePathArray = [String]()
    static var imagesArray = [UIImage]()
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var folderStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
getListOfItems()
//downloadImage()
    }
    
    @IBAction func ViewScreen(_ sender: UIButton) {
         let secondViewController = (self.storyboard?.instantiateViewController(withIdentifier: "selectedImage"))! as! SelectedFolderViewController as SelectedFolderViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
        //        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        ScannedImagesViewController.imagesArray.removeAll()
    }
    func getListOfItems() {
        let storageReference: Void = storage.reference().root().child("images").listAll { (result, error) in
            var folderArray = [String]()
            for prefix in result.prefixes {
                let folderName = prefix.description.replacingOccurrences(of: "gs://flick-efdc4.appspot.com/images/", with: "", options: .caseInsensitive)
                folderArray.append(folderName)
                print(folderArray)
                let button = UIButton()
                print("folders\(folderName)")
                button.setTitle(folderName, for: .normal)
                button.backgroundColor = .blue
                button.addTarget(self, action: #selector(self.openImagesVC), for: .touchUpInside)
                self.folderStackView.addArrangedSubview(button)
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func openImagesVC(_ sender: UIButton!) {
        let imagesVC = SelectedFolderViewController()
        ScannedImagesViewController.self.selectedName = sender.currentTitle ?? ""
        print("sel\(ScannedImagesViewController.selectedName)")

        getImage(folderName: ScannedImagesViewController.selectedName) { (result) in
            print("imagesArray\(result)")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "stack") as! StackViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        print("array\(ScannedImagesViewController.imagesArray)")
        
    }
    
        func downloadImage(imagePath: String) -> UIImage {
            
            let downloadRef = Storage.storage().reference(withPath:imagePath )
            downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
                if let error = error {
                    print("error\(error.localizedDescription)")
                } else {
                
                    self.image = UIImage(data: downloadedImage ?? Data())!
                }
            }
            return image
            
        }
        
        ///MARK:-to display list of images from a specific folder
    func getImage(folderName: String, completion: (Array<UIImage>)->()) {
            
            print(folderName)
            imagePathArray = []
            let storageReference: Void = storage.reference().root().child("images/\(folderName)").listAll { (result, error) in
                print(result.items.description)
                for images in result.items {
                    let imagePath = images.description.replacingOccurrences(of: "gs://flick-efdc4.appspot.com/", with: "")
                    self.imagePathArray.append(imagePath)
                    print(self.imagePathArray)
                    let downloadedImage = self.downloadImage(imagePath: imagePath)
                    ScannedImagesViewController.imagesArray.append(downloadedImage)
                }
            }
        completion(ScannedImagesViewController.imagesArray)
        }
}
