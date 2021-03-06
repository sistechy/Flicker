//
//  DataModel.swift
//  Flick
//
//  Created by Vidhya C on 23/08/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

struct DataModel {
    static var imagePathArray = [String]()
    static var storageReference = Storage.storage()
    static var imagesArray = [UIImage]()
    static var selectedButtonName = ""
    static var selectedImage = UIImage()
    static var userID = (Auth.auth().currentUser?.uid)!
    static var displayName = (Auth.auth().currentUser?.displayName)!
}
