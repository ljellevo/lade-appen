//
//  App.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 06.03.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import Firebase
import Disk

class App {
    let database = Database()
    var algorithms: Algorithms?
    let cacheManagement = CacheManagement()
    let initialization = Initialization()
    
    var user: User?
    var stations: [Station] = []
    var filteredStations: [Station] = []
    var favorites: [Int:Int] = [:]
    
    func initializeApplication(done: @escaping (_ code: Int)-> Void){
        let group = DispatchGroup()
        var verificationCode: Int = -1
        group.enter()
        verifyUserCache(){(code: Int?) -> Void in
            print("User verified")
            verificationCode = code!
            DispatchQueue.main.async {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("User verified")
            let infoGroup = DispatchGroup()
            
            infoGroup.enter()
            self.verifyStationCache(){
                print("Stations verified")
                DispatchQueue.main.async {
                    infoGroup.leave()
                }
            }
            
            infoGroup.enter()
            self.verifyFavoritesCache {
                print("Favorites verified")
                DispatchQueue.main.async {
                    infoGroup.leave()
                }
            }
            
            infoGroup.notify(queue: .main) {
                print("All done")
                self.verifyFilteredStationsCache()
                self.algorithms = Algorithms(user: self.user!, stations: self.stations, filteredStations: self.filteredStations, favorites: self.favorites)
                done(verificationCode)
            }
        }
    }
    
    func verifyStationCache(done: @escaping ()-> Void){
        if cacheManagement.fetchStationCache() != nil {
            stations = cacheManagement.fetchStationCache()!
            done()
        } else {
            database.getStationsFromDatabase {_ in 
                done()
            }
        }
    }
    
    func verifyFilteredStationsCache() {
        if cacheManagement.fetchFilteredStationsCache() != nil{
            filteredStations = cacheManagement.fetchFilteredStationsCache()!
        } else {
            //Regn ut filtrerte stasjoner
        }
    }
    
    func verifyFavoritesCache(done: @escaping ()-> Void){
        if cacheManagement.fetchFavoritesCache() != [-1:-1] {
            favorites = cacheManagement.fetchFavoritesCache()
            done()
        } else {
            database.getFavoritesFromDatabase(){_ in 
                done()
            }
        }
    }
    
    func verifyUserCache(done: @escaping (_ code: Int)-> Void){
        if cacheManagement.fetchUserCache() != nil{
            user = cacheManagement.fetchUserCache()!
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
                        self.user = user
                        self.cacheManagement.updateUserCache(user: user)
                        done(0)
                        return
                    }
                }
                done(1)
            }, withCancel: nil)
        }
    }
    
}
