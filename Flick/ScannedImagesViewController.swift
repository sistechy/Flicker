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
 let storage = Storage.storage()
    @IBOutlet weak var scannedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

downloadImage()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
