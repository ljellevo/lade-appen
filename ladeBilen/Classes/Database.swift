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
    
    func updateUser(user: User){
        ref.child("User_Info").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(
            ["uid": user.uid as String!,
             "email": user.email as String!,
             "firstname": user.firstname as String!,
             "lastname": user.lastname as String!,
             "fastCharge": user.fastCharge as Bool!,
             "parkingFee": user.parkingFee as Bool!,
             "cloudStorage": user.cloudStorage as Bool!,
             "notifications": user.notifications as Bool!,
             "notificationsDuration": user.notificationDuration as Int!,
             "connector": user.connector as [Int]!]
        )
    }
    
    
    func updateEmail(newEmail: String){
        ref.child("User_Info/" + (FIRAuth.auth()?.currentUser?.uid)! + "/email").setValue(newEmail)
    }
    
    func updateFirstname(newFirstname: String){
        ref.child("User_Info/" + (FIRAuth.auth()?.currentUser?.uid)! + "/firstname").setValue(newFirstname)
    }
    
    func updateLastname(newLastname: String){
        ref.child("User_Info/" + (FIRAuth.auth()?.currentUser?.uid)! + "/lastname").setValue(newLastname)
    }
    
    func updateConnector(connectors: [Int]){
        ref.child("User_Info/" + (FIRAuth.auth()?.currentUser?.uid)! + "/connector").setValue(connectors)
    }
    
    func submitBugReport(reportedText: String){
        ref.child("customer_service").child("reported_bugs").childByAutoId().setValue(
            ["uid": (FIRAuth.auth()?.currentUser?.uid)!,
             "email": (FIRAuth.auth()?.currentUser?.email)!,
             "Report": reportedText]
        )
    }
    
    func getStationsFromDatabase(done: @escaping (_ stations: [Station])-> Void){
        var stations: [Station] = []
        let ref = FIRDatabase.database().reference()
        ref.child("stations").observe(.value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        let station = Station(dictionary: eachStation!)
                        //stations.append(station)
                        stations.append(station)
                    }
                }
                
                DispatchQueue.main.async {
                    done(stations)
                }
            }
        }, withCancel: nil)
    }
    
    func getFavoritesFromDatabase(done: @escaping (_ favorites: [Int:Int])-> Void){
        var favorites: [Int:Int] = [:]
        let ref = FIRDatabase.database().reference()
        ref.child("favorites").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        favorites.updateValue(eachStation!["id"] as! Int, forKey: eachStation!["id"] as! Int)
                        //favorites.append(eachStation!["id"] as! Int)
                    }
                }
                DispatchQueue.main.async {
                    done(favorites)
                }
            }
        }, withCancel: nil)
    }
    
    func addFavoriteInDatabase(id: Int){
        ref.child("favorites").child((FIRAuth.auth()?.currentUser?.uid)!).child(String(id)).setValue(
            ["id": id]
        )
        getFavoritesFromDatabase {_ in}
    }
    
    func removeFavoriteInDatabase(id: Int){
        ref.child("favorites").child((FIRAuth.auth()?.currentUser?.uid)!).child(String(id)).removeValue()
        getFavoritesFromDatabase {_ in}
    }
}
