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
    var stationListenerHandle: DatabaseHandle?
    
    func getUserFromDatabase(done: @escaping (_ user: User?)-> Void){
        ref.child("User_Info").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Got value from db")

            
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
                let reduceData = value["reduceData"] as? Bool
                if reduceData == nil {
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
                
                var tutorial = value["tutorial"] as? Bool
                if tutorial == nil {
                    tutorial = true
                }
                
                if error == false {
                    print("User found in database, caching and navigating to home: AppDelegate")
                    
                    let user = User(uid: uid!, email: email!, firstname: firstname!, lastname: lastname!, fastCharge: fastcharge!, parkingFee: parkingfee!, reduceData: reduceData!, notifications: notifications!, notificationDuration: notificationsDuration!, connector: connector!, timestamp: timestamp!, favorites: favorites!, tutorial: tutorial!)
                    done(user)
                } else {
                    print("Got error missing values")
                    done(nil)
                }
            } else {
                print("Value is empty")
                done(nil)
            }
        }, withCancel: { error in
            print("Got error")
            done(nil)
        })
    }
    
    func setUserInDatabase(user: User, done: @escaping (_ code: Int)-> Void){
        ref.child("User_Info").child((Auth.auth().currentUser?.uid)!).updateChildValues(
            ["uid": user.uid as String,
             "email": user.email as String,
             "firstname": user.firstname as String,
             "lastname": user.lastname as String,
             "fastCharge": user.fastCharge as Bool,
             "parkingFee": user.parkingFee as Bool,
             "reduceData": user.reduceData as Bool,
             "notifications": user.notifications as Bool,
             "notificationsDuration": user.notificationDuration as Int,
             "connector": user.connector as [Int],
             "timestamp": user.timestamp as Int64,
             "favorites": user.favorites as [String:Int64],
             "tutorial": user.tutorial as Bool
            ]
        ){
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                done(0)
            } else {
                done(1)
            }
        }
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
                    }
                }
                
                DispatchQueue.main.async {
                    done(stations)
                }
            }
        }, withCancel: nil)
    }
    
    func getStationChecksumFromDatabase(done: @escaping (_ checksum: Checksum)-> Void) {
        ref.child("checksum").child("nobil_data").child("value").observeSingleEvent(of: .value) { snapshot in
            done(Checksum(value: snapshot.value as! String))
        }
    }
    
    func getConnectorDescriptionFromDatabase(done: @escaping (_ stations: [Int:String])-> Void){
        var connectorDescription: [Int:String] = [:]
        ref.child("nobil_database_static").child("connectors").observeSingleEvent(of: .value, with: { (snapshot) in
            DispatchQueue.global().async {
                print(snapshot)
                for children in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                    connectorDescription.updateValue(children.value as! String, forKey: Int(children.key)!)
                }
                DispatchQueue.main.async {
                    done(connectorDescription)
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
                    print(stationId)
                    print(conn![1])
                    DispatchQueue.main.async {
                        done(conn!)
                    }
                }
            }
        }
    }
    
    
    func subscribeToStation(stationId: String, user: User, done: @escaping (_ code: Int)-> Void){
        var errorCode = 1
        let susbscribeTask = DispatchGroup()
        susbscribeTask.enter()
        
        ref.child("User_Info").child(user.uid).child("subscriptions").child(stationId).setValue(
            ["update": Date().getTimestamp(),
             "from": Date().getTimestamp(),
             "to": (Date().getTimestamp() + Int64(user.notificationDuration * 60))]
        ){(error:Error?, ref:DatabaseReference) in
            if error != nil {
                errorCode = 0
            }
            defer {
                susbscribeTask.leave()
            }
            
        }
        
        susbscribeTask.enter()
        ref.child("subscriptions").child(stationId).child("members_subscriptions").updateChildValues([user.uid: Date().getTimestamp()]){(error:Error?, ref:DatabaseReference) in
            if error != nil {
                errorCode = 0
            }
            defer {
                susbscribeTask.leave()
            }
        }
        
        susbscribeTask.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            done(errorCode)
        }))
    }
    
    func unsubscribeToStation(stationId: String, user: User, done: @escaping (_ code: Int)-> Void){
        var errorCode = 1
        let unsusbscribeTask = DispatchGroup()
        unsusbscribeTask.enter()
        ref.child("User_Info").child(user.uid).child("subscriptions").child(stationId).removeValue(){(error:Error?, ref:DatabaseReference) in
            if error != nil {
                errorCode = 0
            }
            defer {
                unsusbscribeTask.leave()
            }
        }
        
        unsusbscribeTask.enter()
        ref.child("subscriptions").child(stationId).child("members_subscriptions").updateChildValues([user.uid: NSNull()]){(error:Error?, ref:DatabaseReference) in
            if error != nil {
                errorCode = 0
            }
            defer {
                unsusbscribeTask.leave()
            }
        }
        unsusbscribeTask.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            done(errorCode)
        }))
    }
    
    func getSubscriptionsFromDatabase(user: User, done: @escaping (_ subscriptions: [Subscription])-> Void){
        ref.child("User_Info").child(user.uid).child("subscriptions").observeSingleEvent(of: .value) { (snapshot) in
            var subscriptions: [Subscription] = []
            for sub in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                let values = sub.value as! [String : Int64]
                if NSNumber(value: (values["to"]!.subtractingReportingOverflow(Date().getTimestamp())).partialValue).intValue >= 0 {
                    subscriptions.append(Subscription(values: sub.value as! [String : Int64], key: sub.key))
                }
            }
            done(subscriptions)
        }
    }
    
    func detatchListenerOnStation(stationId: String){
        ref.child("Realtime").child(stationId).removeAllObservers()
    }
    
    
    func detatchAllListeners(){
        ref.child("Realtime").removeAllObservers()
    }
    
}
