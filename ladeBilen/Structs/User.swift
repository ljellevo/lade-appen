//
//  User.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 10.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct User: Codable {
    var uid: String?
    var email: String?
    var firstname: String?
    var lastname: String?
    var fastCharge: Bool?
    var parkingFee: Bool?
    var cloudStorage: Bool?
    var notifications: Bool?
    var notificationDuration: Int?
    var connector: [Int]?
    var timestamp: Int64?
    var subscriptions: [String: Int64]?
    
    var dictionary: [String: Any] {
        return ["uid": uid!,
                "email": email!,
                "firstname": firstname!,
                "lastname": lastname!,
                "fastcharge": fastCharge!,
                "parkingFee": parkingFee!,
                "cloudStorage": cloudStorage!,
                "notifications": notifications!,
                "notificationsDuration": notificationDuration!,
                "connector": [connector],
                "timestamp": timestamp!,
                "subscriptions": subscriptions!
        ]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }

    
    init(uid: String, email: String, firstname: String, lastname: String, fastCharge: Bool, parkingFee: Bool, cloudStorage: Bool, notifications: Bool, notificationDuration: Int, connector: [Int], timestamp: Int64, subscriptions: [String:Int64]) {
        self.uid = uid
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.fastCharge = fastCharge
        self.parkingFee = parkingFee
        self.cloudStorage = cloudStorage
        self.notifications = notifications
        self.notificationDuration = notificationDuration
        self.connector = connector
        self.timestamp = timestamp
        self.subscriptions = subscriptions
    }
}
