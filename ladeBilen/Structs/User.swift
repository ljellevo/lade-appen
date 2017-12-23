//
//  User.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 10.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct User {
    var firstname: String? = ""
    var lastname: String? = ""
    var email: String? = ""
    
    var connectors: [String?] = [""]
    var parkingFee: Bool? = false
    var fastCharge: Bool? = false
    
    var cloudStorage: Bool? = false
    
    init(firstname: String, lastname: String, email: String, connectors: [String], parkingFee: Bool, fastCharge: Bool, cloudStorage: Bool) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.connectors = connectors
        self.parkingFee = parkingFee
        self.fastCharge = fastCharge
        self.cloudStorage = cloudStorage
    }
}
