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
    var connector: Int?

    
    init(uid: String, email: String, firstname: String, lastname: String, fastCharge: Bool, parkingFee: Bool, cloudStorage: Bool, notifications: Bool, notificationDuration: Int, connector: Int) {
        self.uid = uid
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.fastCharge = fastCharge
        self.parkingFee = parkingFee
        self.notifications = notifications
        self.notificationDuration = notificationDuration
        self.connector = connector
        
    }
}
