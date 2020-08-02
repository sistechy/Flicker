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
    var selectedName = String()
 let storage = Storage.storage()
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var folderStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
getListOfItems()
//downloadImage()
    }
    
    func downloadImage(imageName: String) {
          let downloadRef = Storage.storage().reference(withPath: "images/one.jpg")
          downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
              if let error = error {
                  print("error\(error.localizedDescription)")
              } else {
                  self.scannedImage.image = UIImage(data: downloadedImage ?? Data())
                print(downloadedImage as Any)
              }
          }
      }

    func getListOfItems() {
        let storageReference: Void = storage.reference().root().child("images").listAll { (result, error) in
            var folderArray = [String]()
            for prefix in result.prefixes {
                let folderName = prefix.description.replacingOccurrences(of: "gs://flick-efdc4.appspot.com/images/", with: "", options: .caseInsensitive)
                folderArray.append(folderName)
                print(folderArray)
                let button = UIButton()
                button.setTitle(folderName, for: .normal)
                button.backgroundColor = .blue
                button.addTarget(self, action: #selector(self.openImagesVC), for: .touchUpInside)
                self.selectedName = button.currentTitle ?? "default"
                self.folderStackView.addArrangedSubview(button)
            }
        }

    }
    
    @objc func openImagesVC() {
        let imagesVC = SelectedFolderViewController()
        present(imagesVC, animated: true) {
            imagesVC.getImage(folderName: self.selectedName)
        }
    }
}
