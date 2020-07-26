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

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    let vc = VNDocumentCameraViewController()
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         vc.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        present(vc, animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Found \(scan.pageCount)")

        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            // ... your code here
            print(img)
            print("scans \(i)")
            
            // Add a new document with a generated ID
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "first": "Ada",
                "last": "Lovelace",
                "born": 1815
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
        }
    }

}

