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
    static var imagePathArray = [String]()
    static var imagesArray = [UIImage]()
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var folderStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfItems()
    }
    
    //To get list of folders under images folder and create buttons to represent it
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
    
    //button action to view the images
    @objc func openImagesVC(_ sender: UIButton!) {
        ScannedImagesViewController.self.selectedName = sender.currentTitle ?? ""
        print("sel\(ScannedImagesViewController.selectedName)")
        DataModel.selectedButtonName = sender.currentTitle!
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "stack") as! StackViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
