//
//  StackViewController.swift
//  Flick
//
//  Created by Vidhya C on 16/08/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    @IBOutlet weak var stackoutlet: UIStackView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- sending the selected folder name
        getListOfImages(folderName: DataModel.selectedButtonName)
    }
    
    
    //MARK:-To get list of image paths under selected folder
    func getListOfImages(folderName: String){
        print("foldeer name \(folderName)")
        // Create a reference to the file you want to download
        let imageRef = DataModel.storageReference.reference(withPath: "images/\(folderName)")
        imageRef.listAll { (imagelist, error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                for images in imagelist.items {
                    let imagePath = images.description.replacingOccurrences(of: "gs://flick-efdc4.appspot.com/", with: "")
                    DispatchQueue.main.async {
                        self.downLoadImagesFromPath(paths: imagePath)
                    }
                }
            }
        }
    }
    //MARK:-Downloading the image from the path
    func downLoadImagesFromPath(paths: String) {
        // for path in paths {
        let imageRef = DataModel.storageReference.reference(withPath: paths)
        imageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    let imageView = UIImageView()
                    imageView.image = image
                    self.stackoutlet.addArrangedSubview(imageView)
                }
                
            }
        }
    }
}
