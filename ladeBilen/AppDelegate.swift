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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        //UIApplication.shared.statusBarStyle = .lightContent
        
        if FIRAuth.auth()?.currentUser != nil {
            do{
                if Disk.exists((FIRAuth.auth()?.currentUser?.uid)! + ".json", in: .caches) {
                    GlobalResources.user = try Disk.retrieve((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches, as: User.self)
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "Tab") as! Tab
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                } else {
                    print("User not stored in cache, performing database query")
                    let ref = FIRDatabase.database().reference()
                    ref.child("User_Info").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: { (snapshot) in
                        if let value = snapshot.value as? NSDictionary {
                            var error: Bool = false
                            let uid = value["uid"] as? String
                            if uid == nil {
                                error = true
                            }
                            let email = value["email"] as? String
                            if email == nil {
                                error = true
                            }
                            let firstname = value["firstname"] as? String
                            if firstname == nil {
                                error = true
                            }
                            let lastname = value["lastname"] as? String
                            if lastname == nil {
                                error = true
                            }
                            let fastcharge = value["fastCharge"] as? Bool
                            if fastcharge == nil {
                                error = true
                            }
                            let parkingfee = value["parkingFee"] as? Bool
                            if parkingfee == nil {
                                error = true
                            }
                            let cloudstorage = value["cloudStorage"] as? Bool
                            if cloudstorage == nil {
                                error = true
                            }
                            let notifications = value["notifications"] as? Bool
                            if notifications == nil {
                                error = true
                            }
                            let notificationsDuration = value["notificationsDuration"] as? Int
                            if notificationsDuration == nil {
                                error = true
                            }
                            let connector = value["connector"] as? Int
                            if connector == nil {
                                error = true
                            }
                                
                            if error == false {
                                print("User found in database, caching and navigating to home: AppDelegate")
                                let user = User(uid: uid!, email: email!, firstname: firstname!, lastname: lastname!, fastCharge: fastcharge!, parkingFee: parkingfee!, cloudStorage: cloudstorage!, notifications: notifications!, notificationDuration: notificationsDuration!, connector: connector!)
                                GlobalResources.user = user
                                do {
                                    try Disk.save(user, to: .caches, as: (FIRAuth.auth()?.currentUser?.uid)! + ".json")
                                } catch {
                                    print("User not stored in cache")
                                }
                                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "Tab") as! Tab
                                self.window?.rootViewController = vc
                                self.window?.makeKeyAndVisible()
                                return
                            }
                        }
                        print("User not found in database, will navigate user to registration: AppDelegate")
                        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Register") as! Register
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()

                    }, withCancel: nil)
                }
            }catch {
                print("Error reading cache")
            }
            
        } else {
            print("Login")
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        return true
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

