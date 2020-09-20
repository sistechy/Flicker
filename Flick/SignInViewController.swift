//
//  SignInViewController.swift
//  Flick
//
//  Created by Vidhya C on 30/08/20.
//  Copyright © 2020 Vidhya C. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseUI
import AuthenticationServices
import CryptoKit

class SignInViewController: UIViewController, GIDSignInDelegate, FUIAuthDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    //Google Sign In button
    @IBOutlet weak var signInButton: GIDSignInButton!
    let provider = ASAuthorizationAppleIDProvider()
    var request: ASAuthorizationRequest! = nil
    var controller: ASAuthorizationController! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            navigateToHomePage()
        }
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
        request = provider.createRequest()
        controller = ASAuthorizationController(authorizationRequests: [request])
    }
    
    
    
    //Google Sign In Action
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.\(authResult?.user.uid)")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.navigateToHomePage()
            }
        }
    }
    
    
    @IBAction func appleSignInAction(_ sender: UIButton) {
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("authData\(authDataResult?.credential)")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as? ViewController
        self.navigationController?.pushViewController(newViewController ?? UIViewController(), animated: true)
//        if let user = authDataResult?.user {
//            print("Successs \(user.uid) And \(user.email)")
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as? ViewController
//            self.navigationController?.pushViewController(newViewController ?? UIViewController(), animated: true)
//        }
    }
    
    func getCredentialState(forUserID userID: String,
                            completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void){
        print(userID)
//        let user = authorization.credential.user
//        provider.getCredentialState(forUserID: user) { state, error in
//            // Check for error and examine the state.
//        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print(authorization.credential)
       
        }
    
    func navigateToHomePage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as? ViewController else { return }
        self.navigationController?.show(newViewController, sender: self)
    }

}
