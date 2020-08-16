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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("All\(ScannedImagesViewController.imagesArray)")
        for images in ScannedImagesViewController.imagesArray {
         let imageView = UIImageView()
            imageView.image = images
           
            
            
            stackoutlet.addArrangedSubview(imageView)
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
