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

        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            // ... your code here
            print(img)
            print("scans \(i)")
            uploadImage(image: img)
        }
    }

    
    func uploadImage(image: UIImage) {
        let uploadRef = Storage.storage().reference(withPath: "images/one.jpg")
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
    
    func downloadImage() {
        let downloadRef = Storage.storage().reference(withPath: "images/one.jpg")
        downloadRef.getData(maxSize: 4 * 1024 * 1024) { (downloadedImage, error) in
            if let error = error {
                print("error\(error.localizedDescription)")
            } else {
                self.scannedImage.image = UIImage(data: downloadedImage ?? Data())
            }
        }
    }
}

