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
    override func viewWillAppear(_ animated: Bool) {
        getImage(folderName: ScannedImagesViewController.selectedName)
        print("static\(ScannedImagesViewController.selectedName)")
    }
    

    func downloadImage(imageName: String) {
             let downloadRef = Storage.storage().reference(withPath: "images/ok/2020-08-09 18:24:51 +00000.jpg")
             downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
                 if let error = error {
                     print("error\(error.localizedDescription)")
                 } else {
                     self.imageViewOutlet.image = UIImage(data: downloadedImage ?? Data())
                   print(downloadedImage as Any)
                 }
             }
         }
    
    func getImage(folderName: String) {
        print(folderName)
        let storageReference: Void = storage.reference().root().child("images/\(folderName)").listAll { (result, error) in
            print(result.items.description)
            self.downloadImage(imageName: "gs://flick-efdc4.appspot.com/images/trial/2020-08-02 08:06:26 +0000.jpg")
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
