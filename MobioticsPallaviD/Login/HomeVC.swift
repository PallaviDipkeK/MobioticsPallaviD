//
//  HomeVC.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class HomeVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let login = UserDefaults.standard.value(forKey: "isLogin") as? String,login != "LoggedIn"{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    
    @IBAction func didSelectStartBtn(_ sender: Any) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let videolistVC = mainStoryBoard.instantiateViewController(withIdentifier: "listNav")
        self.present(videolistVC, animated: true, completion: nil)
    }
    
    @IBAction func disSelectLogoutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set("LoggedOut", forKey: "isLogin")
            let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = loginPage
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
