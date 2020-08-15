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
    var imagesArray = [UIImage]()
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
    
    @IBAction func openImagesVC(_ sender: UIButton!) {
        let imagesVC = SelectedFolderViewController()
        ScannedImagesViewController.self.selectedName = sender.currentTitle ?? ""
        print("sel\(ScannedImagesViewController.selectedName)")
        getImage(folderName: ScannedImagesViewController.selectedName)
         print("array\(imagesArray)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selectedImage") as! SelectedFolderViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
        func downloadImage(imagePath: String) -> [UIImage] {
            
            let downloadRef = Storage.storage().reference(withPath:imagePath )
            downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
                if let error = error {
                    print("error\(error.localizedDescription)")
                } else {
                    
                    let imageView = UIImageView()
                    let image = UIImage(data: downloadedImage ?? Data())!
    //                self.imageViewOutlet.image = self.image
                    self.imagesArray.append(image)
                    print(self.image)
                }
            }
            return  self.imagesArray
            
        }
        
        ///MARK:-to display list of images from a specific folder
        func getImage(folderName: String) {
            
            print(folderName)
            imagePathArray = []
            let storageReference: Void = storage.reference().root().child("images/\(folderName)").listAll { (result, error) in
                print(result.items.description)
                for images in result.items {
                    let imagePath = images.description.replacingOccurrences(of: "gs://flick-efdc4.appspot.com/", with: "")
                    self.imagePathArray.append(imagePath)
                    print(self.imagePathArray)
                    
                    self.downloadImage(imagePath: imagePath)
                }
            }
        }
}
