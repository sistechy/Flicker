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
import FirebaseUI
class ScannedImagesViewController: UIViewController, ActivityIndicatorPresenter {
    var activityIndicator = UIActivityIndicatorView()
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
        showActivityIndicator()
        getListOfItems()
        
    }
    
    //To get list of folders under images folder and create buttons to represent it
    func getListOfItems() {
        let userID : String = (Auth.auth().currentUser?.uid)!
        let storageReference: Void = storage.reference().root().child("\(userID)").listAll { (result, error) in
            if let error = error {
                print("CheckTest\(error)")
                self.hideActivityIndicator()
                DispatchQueue.main.async {
                    self.showAlert(message: "oops", VC: self)
                }
                return
            } else {
                self.hideActivityIndicator()
            }
            for prefix in result.prefixes {
                
                let userID : String = (Auth.auth().currentUser?.uid)!
                let folderName = prefix.description.replacingOccurrences(of: "gs://flick-efdc4.appspot.com/\(userID)/", with: "", options: .caseInsensitive)
                self.createButton(folderName: folderName)
            }
        
        }
       
        
    }
    
    func createButton(folderName: String) {
        let button = UIButton()
        print("folders\(folderName)")
        button.setTitle(folderName, for: .normal)
        button.addConstraint(button.heightAnchor.constraint(equalToConstant: 50))
        button.backgroundColor = .blue
        button.layer.cornerRadius =  20
        button.addTarget(self, action: #selector(self.openImagesVC), for: .touchUpInside)
        self.folderStackView.addArrangedSubview(button)
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


//func alert(viewController: UIViewController, functionality: Functionality) {
//    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//    loadingIndicator.hidesWhenStopped = true
//    loadingIndicator.style = UIActivityIndicatorView.Style.medium
//    loadingIndicator.startAnimating()
//    alert.view.addSubview(loadingIndicator)
//    switch functionality {
//    case .show:
//        viewController.present(alert, animated: true, completion: nil)
//    default:
//        alert.dismiss(animated: false, completion: nil)
//    }
//}
