//
//  ViewController.swift
//  Flick
//
//  Created by Vidhya C on 26/07/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import VisionKit
import Firebase
import FirebaseStorage
import FirebaseUI
import FirebaseAuth

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    //For document scan
    let vc = VNDocumentCameraViewController()
    let storage = Storage.storage()
    
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var viewScanButton: UIButton!
    
    @IBOutlet weak var GreetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //To set delegate for document view
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        vc.delegate = self
        GreetLabel.text = "Hi,\n\((Auth.auth().currentUser?.displayName)!)"
        scanButton.layer.cornerRadius =  20
        viewScanButton.layer.cornerRadius = 20
    }
    
    @IBAction func scanAction(_ sender: UIButton) {
        present(vc, animated: true)
    }
    
    //Save button action in document VC
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Found \(scan.pageCount)")
        var imgArray: Array<UIImage> = []
        for i in 0 ..< scan.pageCount {
            let image = scan.imageOfPage(at: i)
            imgArray.append(image)
        }
        dismiss(animated: true) {
            self.getFileName(img: imgArray)
        }
    }
    
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        // You are responsible for dismissing the controller.
        controller.dismiss(animated: true)
    }
    
    //To upload scanned images in firebase storage
    func uploadImage(imagesArray: Array<UIImage>, folderName: String) {
        var count = 0
        let date = Date()
        for image in imagesArray {
            let userID : String = (Auth.auth().currentUser?.uid)!
            let uploadRef = Storage.storage().reference(withPath: "\(userID)/\(folderName)/\(date)\(count).jpg")
            count+=1
            guard let imageData = image.jpegData(compressionQuality: 0.75) else {
                return
            }
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                if let error = error {
                    print("error\(error)")
                } else {
                    print("success \(String(describing: downloadMetadata))")
                }
            }
        }
    }
    
    
    // Alert to prompt user for folder name
    func getFileName(img: Array<UIImage>) {
        let alertController = UIAlertController(title: "Save Image", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Folder Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.uploadImage(imagesArray: img, folderName: firstTextField.text ?? "")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("logout Successfull")
            navigationController?.popToRootViewController(animated: true)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}

