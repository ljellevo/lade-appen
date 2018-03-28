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
import SwiftyJSON

class DatabaseApp {
    let ref = Database.database().reference()
    var stationListenerHandle: DatabaseHandle?
    
    func getUserFromDatabase(done: @escaping (_ user: User?)-> Void){
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
                var favorites = value["favorites"] as? [String:Int64]
                if favorites == nil {
                    favorites = [:]
                }
                
                if error == false {
                    print("User found in database, caching and navigating to home: AppDelegate")
                    
                    let user = User(uid: uid!, email: email!, firstname: firstname!, lastname: lastname!, fastCharge: fastcharge!, parkingFee: parkingfee!, cloudStorage: cloudstorage!, notifications: notifications!, notificationDuration: notificationsDuration!, connector: connector!, timestamp: timestamp!, favorites: favorites!)
                    done(user)
                } else {
                    done(nil)
                }
            }
        }, withCancel: nil)
    }
    
    func setUserInDatabase(user: User){
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
             "connector": user.connector as [Int]!,
             "timestamp": user.timestamp as Int64!,
             "favorites": user.favorites as [String:Int64]!]
        )
    }
    
    func submitBugReport(reportedText: String){
        let values: [String: String] = ["uid": (Auth.auth().currentUser?.uid)!,
                                       "email": (Auth.auth().currentUser?.email)!,
                                       "Report": reportedText]
        ref.child("customer_service").child("reported_bugs").childByAutoId().setValue(values)
    }
    
    func getStationsFromDatabase(done: @escaping (_ stations: [Station])-> Void){
        var stations: [Station] = []
        ref.child("stations").observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        let station = Station(dictionary: eachStation!)
                        stations.append(station)
                        print("Update")
                    }
                }
                
                DispatchQueue.main.async {
                    done(stations)
                }
            }
        }, withCancel: nil)
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
    
    func listenOnStation(stationId: String, done: @escaping (_ conn: NSArray)-> Void){
        stationListenerHandle = ref.child("Realtime").child(stationId).observe(.value) { (snapshot) in
            DispatchQueue.global().async {
                if let dict = snapshot.value as? [String : AnyObject] {
                    let conn = dict["conn"] as? NSArray
                    print(conn![1])
                    DispatchQueue.main.async {
                        print("Update DatabaseApp")
                        done(conn!)
                    }
                }
            }
        }
    }
    
    func detatchListenerOnStation(stationId: String){
        ref.child("Realtime").child(stationId).removeObserver(withHandle: stationListenerHandle!)
    }
    
}
