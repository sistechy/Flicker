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

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    let vc = VNDocumentCameraViewController()
    let storage = Storage.storage()

    @IBOutlet weak var scannedImage: UIImageView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         vc.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    @IBAction func scanAction(_ sender: UIButton) {
        present(vc, animated: true)
    }
    
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

    
    func uploadImage(imagesArray: Array<UIImage>, folderName: String) {
        var count = 0
        let date = Date()
        for image in imagesArray {
            let uploadRef = Storage.storage().reference(withPath: "images/\(folderName)/\(date)\(count).jpg")
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
}

