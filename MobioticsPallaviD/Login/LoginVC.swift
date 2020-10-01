//
//  LoginVC.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
class LoginVC: BaseVC, GIDSignInUIDelegate {
    @IBOutlet weak var btnSignIn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
  
    @IBAction func googleLoginButton(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
}

extension LoginVC : GIDSignInDelegate {
 
   // Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print("An error occured during Google Authentication")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
           if (error) != nil {
                print("Google Authentification Fail")
               
            } else {
                print("Google Authentification Success")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homevc = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            UIApplication.shared.delegate?.window??.rootViewController = homevc
            }
        }
    }
}

//handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//    // ...
//}
//MainViewController.swift
//Auth.auth().removeStateDidChangeListener(handle!)
