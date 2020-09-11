//
//  Utility.swift
//  Flick
//
//  Created by Vidhya C on 11/09/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import Foundation
import UIKit

//struct Utility {
//
//    static func alert(viewController: UIViewController, functionality: Functionality) {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.medium
//        loadingIndicator.startAnimating()
//        alert.view.addSubview(loadingIndicator)
//        switch functionality {
//        case .show:
//            viewController.present(alert, animated: true, completion: nil)
//        default:
//            alert.dismiss(animated: false, completion: nil)
//        }
//    }
//}
//
//
enum Functionality {
    case show
    case hide
}

/// Used for ViewControllers that need to present an activity indicator when loading data.
public protocol ActivityIndicatorPresenter {
    
    /// The activity indicator
    var activityIndicator: UIActivityIndicatorView { get }
    
    /// Show the activity indicator in the view
    func showActivityIndicator()
    
    /// Hide the activity indicator in the view
    func hideActivityIndicator()
}

public extension ActivityIndicatorPresenter where Self: UIViewController {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.style = .large
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would like
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    func showAlert(message: String, VC: UIViewController) {
         DispatchQueue.main.async {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
            VC.present(VC, animated: true, completion: nil)
        }
    }
}
