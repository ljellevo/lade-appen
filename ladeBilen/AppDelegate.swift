//
//  AppDelegate.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import Disk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let app = App()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
        //deleteCache()
        //logOut()
        if Auth.auth().currentUser != nil {
            app.initializeApplication(){(code: Int) -> Void in
                print("----AppDelegate return value----")
                print(code)
                if code == 0 {
                    self.toHome(app)
                } else if code == 1 {
                    self.toRegister(app)
                } else {
                    self.toLogin(app)
                }
            }
        } else {
            toLogin(app)
        }
        return true
 
    }

    func deleteCache(){
        do {
            try Disk.remove((Auth.auth().currentUser?.uid)! + ".json", from: .caches)
            try Disk.remove(Constants.PATHS.FILTERED_STATION_CACHE, from: .caches)
            try Disk.remove(Constants.PATHS.STATION_CACHE_PATH, from: .caches)
            print("Removed cache")
        } catch {
            print("Could not remove cache")
        }
    }
    
    func logOut(){
        do{
            try Auth.auth().signOut()
        } catch {
            print ("Error")
        }
    }
    
    func toLogin(_ app: App){
        print("Login")
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        vc.app = app
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    func toHome(_ app: App){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let tabVC = storyBoard.instantiateViewController(withIdentifier: "TabHome") as! UITabBarController
        let vc = tabVC.viewControllers![1] as! UINavigationController
        let homeVC = vc.viewControllers.first as! Home
        homeVC.app = app
        self.window?.rootViewController = tabVC
        self.window?.makeKeyAndVisible()
    }
    
    func toRegister(_ app: App){
        print("User not found in database, will navigate user to registration: AppDelegate")
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Register") as! Register
        vc.app = app
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

