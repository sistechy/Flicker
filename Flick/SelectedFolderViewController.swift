//
//  SelectedFolderViewController.swift
//  Flick
//
//  Created by Vidhya C on 02/08/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import Firebase
import Photos

class SelectedFolderViewController: UIViewController {
    let storage = Storage.storage()
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var imagesStackView: UIStackView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    var image = UIImage()
    var selectedFolderName: String?
    var imagePathArray = [String]()
    var imagesArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionViewOutlet.delegate = self
//        collectionViewOutlet.dataSource = self
//        getImage(folderName: ScannedImagesViewController.selectedName)
        
    }
   
    

    
}


extension SelectedFolderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//       print("array\(ScannedImagesViewController.imagesArray)")
//        print("count \(ScannedImagesViewController.imagesArray.count)")
//        return ScannedImagesViewController.imagesArray.count
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        cell?.imageoutlet.image = imagesArray[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    
}
