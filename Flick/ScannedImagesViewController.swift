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
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var folderStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
getListOfItems()
//downloadImage()
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
    
    @objc func openImagesVC(sender: UIButton) {
        let imagesVC = SelectedFolderViewController()
        ScannedImagesViewController.self.selectedName = sender.currentTitle ?? ""
        print("sel\(ScannedImagesViewController.selectedName)")
        self.navigationController?.pushViewController(imagesVC, animated: true)
//        self.present(imagesVC, animated: true) {
//            imagesVC.getImage(folderName: self.selectedName)
//        }
    }
}
