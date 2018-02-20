//
//  Database.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 21.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Disk

class Database {
    let ref = FIRDatabase.database().reference()
    
    func updateUser(){
        
        ref.child("User_Info").child((GlobalResources.user?.uid)!).setValue(
            ["uid": GlobalResources.user?.uid! as String!,
             "email": GlobalResources.user?.email! as String!,
             "firstname": GlobalResources.user?.firstname! as String!,
             "lastname": GlobalResources.user?.lastname! as String!,
             "fastCharge": GlobalResources.user?.fastCharge! as Bool!,
             "parkingFee": GlobalResources.user?.parkingFee! as Bool!,
             "cloudStorage": GlobalResources.user?.cloudStorage! as Bool!,
             "notifications": GlobalResources.user?.notifications! as Bool!,
             "notificationsDuration": GlobalResources.user?.notificationDuration! as Int!,
             "connector": GlobalResources.user?.connector! as [Int]!]
        )
        updateUserCache()
    }
    
    
    func updateUserCache(){
        do {
            try Disk.save(GlobalResources.user, to: .caches, as: (FIRAuth.auth()?.currentUser?.uid)! + ".json")
        } catch {
            print("User not stored in cache")
        }
    }
    
    func updateStationCache(){
        do {
            try Disk.save(GlobalResources.stations, to: .caches, as: "stations.json")
        } catch {
            print("Station not stored in cache")
        }
    }
    
    func updateFavoriteCache(){
        do {
            try Disk.save(GlobalResources.favorites, to: .caches, as: "favorites.json")
        } catch {
            print("Favorites not stored in cache")
        }
    }
    
    func updateEmail(){
        ref.child("User_Info/" + GlobalResources.user!.uid! + "/email").setValue(GlobalResources.user!.email!)
        updateUserCache()
    }
    
    func updateFirstname(){
        ref.child("User_Info/" + GlobalResources.user!.uid! + "/firstname").setValue(GlobalResources.user!.firstname!)
        updateUserCache()
    }
    
    func updateLastname(){
        ref.child("User_Info/" + GlobalResources.user!.uid! + "/lastname").setValue(GlobalResources.user!.lastname!)
        updateUserCache()
    }
    
    func updateConnector(){
        ref.child("User_Info/" + GlobalResources.user!.uid! + "/connector").setValue(GlobalResources.user!.connector!)
        updateUserCache()
    }
    
    func submitBugReport(reportedText: String){
        ref.child("customer_service").child("reported_bugs").childByAutoId().setValue(
            ["uid": GlobalResources.user?.uid,
             "email": GlobalResources.user?.email,
             "Report": reportedText]
        )
    }
    
    func getStationsFromDatabase(finished: @escaping () -> Void){
        var stations: [Station] = []
        let ref = FIRDatabase.database().reference()
        ref.child("stations").observe(.value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        let station = Station(dictionary: eachStation!)
                        stations.append(station)
                    }
                }
                GlobalResources.stations = stations
                self.updateStationCache()
                DispatchQueue.main.async {
                    finished()
                }
            }
        }, withCancel: nil)
    }
    
    func getFavoritesFromDatabase(finished: @escaping () -> Void){
        var favorites: [Int] = []
        let ref = FIRDatabase.database().reference()
        ref.child("favorites").child((GlobalResources.user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        favorites.append(eachStation!["id"] as! Int)
                    }
                }
                GlobalResources.favorites = favorites
                self.updateFavoriteCache()
                DispatchQueue.main.async {
                    finished()
                }
            }
        }, withCancel: nil)
    }
    
    func addFavoriteInDatabase(id: Int){
        ref.child("favorites").child((GlobalResources.user?.uid)!).child(String(id)).setValue(
            ["id": id]
        )
        GlobalResources.favorites.append(id)
        updateFavoriteCache()
    }
    
    func removeFavoriteInDatabase(id: Int){
        ref.child("favorites").child((GlobalResources.user?.uid)!).child(String(id)).removeValue()
        updateFavoriteCache()
    }
}
