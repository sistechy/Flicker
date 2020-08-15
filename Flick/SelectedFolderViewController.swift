//
//  SelectedFolderViewController.swift
//  Flick
//
//  Created by Vidhya C on 02/08/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import Firebase

class SelectedFolderViewController: UIViewController {
    let storage = Storage.storage()
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var imagesStackView: UIStackView!
    var image = UIImage()
    var selectedFolderName: String?
    var imagePathArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage(folderName: ScannedImagesViewController.selectedName)
        
    }
   
    
    func downloadImage(imagePath: String) -> UIImage? {
        
        let downloadRef = Storage.storage().reference(withPath:imagePath )
        downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
            if let error = error {
                print("error\(error.localizedDescription)")
            } else {
                
                let imageView = UIImageView()
                self.image = UIImage(data: downloadedImage ?? Data())!
                self.imageViewOutlet.image = self.image
                print(self.image)
            }
        }
        return image
        
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
