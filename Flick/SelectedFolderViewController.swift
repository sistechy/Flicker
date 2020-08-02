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
    var selectedFolderName: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

//    func downloadImage(imageName: String) {
//             let downloadRef = Storage.storage().reference(withPath: "images/one.jpg")
//             downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
//                 if let error = error {
//                     print("error\(error.localizedDescription)")
//                 } else {
//                     self.scannedImage.image = UIImage(data: downloadedImage ?? Data())
//                   print(downloadedImage as Any)
//                 }
//             }
//         }
    
    func getImage(folderName: String) {
        print(folderName)
        let storageReference: Void = storage.reference().root().child("images\(folderName)").listAll { (result, error) in
            print(result.items.description)
        }
    }
    
//    func getListOfImages(folderName: String) {
//        let storageReference: Void = storage.reference().root().child("images\(folderName)").listAll { (result, error) in
//            for images in result.items {
//                imageViewOutlet.image =
//            }
//        }
//    }

}
