//
//  Verification.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 13.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Disk

class Verification {
    let database = Database()


    func checkAccount(handler: @escaping ((Int)->Void)){
        do{
            if Disk.exists((FIRAuth.auth()?.currentUser?.uid)! + ".json", in: .caches) {
                GlobalResources.user = try Disk.retrieve((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches, as: User.self)
                handler(0)
            } else {
                print("User not stored in cache, performing database query")
                decodeAccountSnapshot(){ (code) in
                    print("--2-- Account status code:")
                    print(code)
                    handler(code)

                }
            }
        }catch{
            print("Error reading cache, performing database query")
            decodeAccountSnapshot(){ (code) in
                print("--2-- Account status code:")
                print(code)
                handler(code)
            }
        }
        handler(-1)
    }
    
    
    func decodeAccountSnapshot(handler: @escaping ((Int)->Void)){
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
                    handler(0)
                } else {
                    handler(2)
                }

            }
        }, withCancel: nil)
    }
    
    func checkStationsCache(finished: @escaping () -> Void) {
        do {
            if Disk.exists("stations.json", in: .caches) {
                GlobalResources.stations = try Disk.retrieve("stations.json", from: .caches, as: [Station].self)
                return
            } else {
                database.getStationsFromDatabase {
                    print("--Stations--")
                    finished()
                }
            }
        } catch {
            database.getStationsFromDatabase {
                print("--Stations--")
                finished()
            }
        }
    }
    
    func checkFavoritesCache(finished: @escaping () -> Void) {
        do {
            if Disk.exists("favorites.json", in: .caches){
                GlobalResources.favorites = try Disk.retrieve("favorites.json", from: .caches, as: [Int].self)
                return
            } else {
                database.getFavoritesFromDatabase(){
                    print("--Favorites--")
                    finished()
                }
            }
        } catch {
            database.getFavoritesFromDatabase(){
                print("--Favorites--")
                finished()
            }
        }
    }
}
