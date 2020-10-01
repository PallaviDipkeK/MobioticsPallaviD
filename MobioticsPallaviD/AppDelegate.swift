//
//  AppDelegate.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
      if let login = UserDefaults.standard.value(forKey: "isLogin") as? String,login == "LoggedIn"{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homevc = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            UIApplication.shared.delegate?.window??.rootViewController = homevc
        }else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            UIApplication.shared.delegate?.window??.rootViewController = loginvc
        }
        return true
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleAuthentication = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        if googleAuthentication{
            defaults.set("LoggedIn", forKey: "isLogin")
        }
        return googleAuthentication
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataClass.saveContext()
    }
    
    
}

