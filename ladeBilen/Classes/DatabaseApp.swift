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

class DatabaseApp {
    let ref = Database.database().reference()
    
    func fetchUserFromDatabase(done: @escaping (_ user: User?)-> Void){
        ref.child("User_Info").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                let timestamp = value["timestamp"] as? Int64
                if timestamp == nil {
                    error = true
                }
                
                if error == false {
                    print("User found in database, caching and navigating to home: AppDelegate")
                    
                     let user = User(uid: uid!, email: email!, firstname: firstname!, lastname: lastname!, fastCharge: fastcharge!, parkingFee: parkingfee!, cloudStorage: cloudstorage!, notifications: notifications!, notificationDuration: notificationsDuration!, connector: connector!, timestamp: timestamp!)
                    done(user)
                } else {
                    done(nil)
                }
            }
        }, withCancel: nil)
    }
    
    func updateUser(user: User){
        ref.child("User_Info").child((Auth.auth().currentUser?.uid)!).setValue(
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
        ref.child("User_Info/" + (Auth.auth().currentUser?.uid)! + "/email").setValue(newEmail)
    }
    
    func updateFirstname(newFirstname: String){
        ref.child("User_Info/" + (Auth.auth().currentUser?.uid)! + "/firstname").setValue(newFirstname)
    }
    
    func updateLastname(newLastname: String){
        ref.child("User_Info/" + (Auth.auth().currentUser?.uid)! + "/lastname").setValue(newLastname)
    }
    
    func updateConnector(connectors: [Int]){
        ref.child("User_Info/" + (Auth.auth().currentUser?.uid)! + "/connector").setValue(connectors)
    }
    
    func submitBugReport(reportedText: String){
        let values: [String: String] = ["uid": (Auth.auth().currentUser?.uid)!,
                                       "email": (Auth.auth().currentUser?.email)!,
                                       "Report": reportedText]
        ref.child("customer_service").child("reported_bugs").childByAutoId().setValue(values)
    }
    
    func getStationsFromDatabase(done: @escaping (_ stations: [Station])-> Void){
        var stations: [Station] = []
        ref.child("stations").observe(.value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        let station = Station(dictionary: eachStation!)
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
        ref.child("favorites").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        favorites.updateValue(eachStation!["id"] as! Int, forKey: eachStation!["id"] as! Int)
                    }
                }
                DispatchQueue.main.async {
                    done(favorites)
                }
            }
        }, withCancel: nil)
    }
    
    func addFavoriteToDatabase(id: Int){
        ref.child("favorites").child((Auth.auth().currentUser?.uid)!).child(String(id)).setValue(
            ["id": id]
        )
    }
    
    func removeFavoriteFromDatabase(id: Int){
        ref.child("favorites").child((Auth.auth().currentUser?.uid)!).child(String(id)).removeValue()
    }
    
    func getUserTimestampFromDatabase(done: @escaping (_ done: Int64)-> Void){
        ref.child("User_Info").child((Auth.auth().currentUser?.uid)!).child("timestamp").observeSingleEvent(of: .value) { (snapshot) in
            if let timestamp = snapshot.value as? Int64 {
                done(timestamp)
            } else {
                done(-1)
            }
        }
    }
}
