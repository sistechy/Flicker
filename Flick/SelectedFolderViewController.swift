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

    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var imagesStackView: UIStackView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
//        getImage(folderName: ScannedImagesViewController.selectedName)
        print("Final\(ScannedImagesViewController.imagesArray)")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("Final\(ScannedImagesViewController.imagesArray)")
    }
    

    
}


extension SelectedFolderViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

//       print("array\(ScannedImagesViewController.imagesArray)")
//        print("count \(ScannedImagesViewController.imagesArray.count)")
//        return ScannedImagesViewController.imagesArray.count
        ScannedImagesViewController.imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        print("resultset\(ScannedImagesViewController.imagesArray[0])")
        cell?.imageoutlet.image =  ScannedImagesViewController.imagesArray[0]
        return cell ?? UICollectionViewCell()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        cell?.imageoutlet.layer.masksToBounds = true
        cell?.imageoutlet.layer.cornerRadius = (cell?.imageoutlet.frame.height)! / 2
    }
    
    
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: collectionView.bounds.width, height: 500)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
//
//        return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
//
//        return 0
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
//
//        return 0
//    }


}
