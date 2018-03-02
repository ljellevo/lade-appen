//
//  Initialization.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import UIKit
import Disk
import Firebase

class Initialization {
    let database = Database()
    
    
    func verifyApplicationParameters(done: @escaping (_ code: Int)-> Void){
        let group = DispatchGroup()
        var verificationCode: Int = -1
        group.enter()
        verifyUserCache(){(code: Int?) -> Void in

            print("User verified")
            print(code!)
            verificationCode = code!
            DispatchQueue.main.async {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("User verified")
            let infoGroup = DispatchGroup()
            
            group.enter()
            self.verifyStationCache(){
                print("Stations verified")
                DispatchQueue.main.async {
                    group.leave()
                }
            }
        
            group.enter()
            self.verifyFavoritesCache {
                print("Favorites verified")
                DispatchQueue.main.async {
                    group.leave()
                }
            }
            
            infoGroup.notify(queue: .main) {
                print("All done")
                done(verificationCode)
            }
        }
    }
    
    func verifyStationCache(done: @escaping ()-> Void){
        do {
            if Disk.exists("stations.json", in: .caches) {
                GlobalResources.stations = try Disk.retrieve("stations.json", from: .caches, as: [Station].self)
                print("Stations is cached")
                done()
            } else {
                print("Could not find stations cache, asking database")
                database.getStationsFromDatabase {
                    done()
                }
            }
        } catch {
            print("Could not retrieve stations cache, asking database")
            database.getStationsFromDatabase {
                done()
            }
        }
    }
    
    func verifyFavoritesCache(done: @escaping ()-> Void){
        do {
            if Disk.exists("favorites.json", in: .caches){
                GlobalResources.favorites = try Disk.retrieve("favorites.json", from: .caches, as: [Int:Int].self)
                done()
            } else {
                print("Could not find favorites cache, asking database")
                database.getFavoritesFromDatabase(){
                    done()
                }
            }
        } catch {
            print("Could not retrieve favorites cache, asking database")
            database.getFavoritesFromDatabase(){
                done()
            }
        }
    }
    
    func verifyUserCache(done: @escaping (_ code: Int)-> Void){
        do{
            if Disk.exists((FIRAuth.auth()?.currentUser?.uid)! + ".json", in: .caches) {
                GlobalResources.user = try Disk.retrieve((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches, as: User.self)
                //toHome()
                done(0)
            } else {
                print("User not stored in cache, performing database query")
                let ref = FIRDatabase.database().reference()
                ref.child("User_Info").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                        var connector = value["connector"] as? [Int]
                        if connector == nil {
                            connector = []
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
                            //self.toHome()
                            done(0)
                            return
                        }
                    }
                    //self.toRegister()
                    done(1)
                }, withCancel: nil)
            }
        }catch {
            print("Error reading cache")
        }
    }
    
    
    
}
