//
//  SelectedImageViewController.swift
//  Flick
//
//  Created by Vidhya C on 31/08/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import PDFKit

class SelectedImageViewController: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedImageView.image = DataModel.selectedImage
    }
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        save(photo: DataModel.selectedImage, toAlbum: "Flick-save") { (result, error) in
            print(error)
//            if let error = error {
//                // we got back an error!
//                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(ac, animated: true)
//            } else {
//                let ac = UIAlertController(title: "Saved!", message: "Your document image has been saved to your photos.", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(ac, animated: true)
//            }
        }
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        guard let docPDF = [DataModel.selectedImage].makePDF() else { return  }
        let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(DataModel.selectedImage).pdf")
//
//        let resourceDocPath = NSHomeDirectory().appending("/Documents/yourPDF.pdf")
//
//        unlink(resourceDocPath)
//
        do {
            try docPDF.write(to: pathURL)
        }catch{
            print("Error while writting")
        }
//
//        print(resourceDocPath)
        savePDF(pdf: docPDF)
    }
    
    @available(iOS 11.0, *)
    func savePDF(pdf: PDFDocument) {
        guard let documentData = pdf.dataRepresentation() else { return }
        let activityController = UIActivityViewController(activityItems: [documentData], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    
    
    func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var placeholder: PHObjectPlaceholder?

            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (created, error) in
                var album: PHAssetCollection?
                if created {
                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
                    album = collectionFetchResult?.firstObject
                }

                completionHandler(album)
            })
        }
    }
    
    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

            if let album = collections.firstObject {
                completionHandler(album)
            } else {
                self?.createAlbum(withTitle: title, completionHandler: { (album) in
                    completionHandler(album)
                })
            }
        }
    }
    
    func save(photo: UIImage, toAlbum titled: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        getAlbum(title: titled) { (album) in
            DispatchQueue.global(qos: .background).async {
                PHPhotoLibrary.shared().performChanges({
                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
                    let assets = assetRequest.placeholderForCreatedAsset
                        .map { [$0] as NSArray } ?? NSArray()
                    let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
                    albumChangeRequest?.addAssets(assets)
                }, completionHandler: { (success, error) in
                    completionHandler(success, error)
                })
            }
        }
    }
    func savePdf(urlString:String, fileName:String) {
            DispatchQueue.main.async {
                let url = URL(string: urlString)
                let pdfData = try? Data.init(contentsOf: url!)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "YourAppName-\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }

        func showSavedPdf(url:String, fileName:String) {
            if #available(iOS 10.0, *) {
                do {
                    let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                    for url in contents {
                        if url.description.contains("\(fileName).pdf") {
                           // its your file! do what you want with it!

                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
    }

    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("YourAppName-\(fileName).pdf") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }

}


extension Array where Element: UIImage {

      func makePDF()-> PDFDocument? {
        let pdfDocument = PDFDocument()
        for (index,image) in self.enumerated() {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: index)
        }
        return pdfDocument
    }
}



