//
//  User.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 10.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var email: String?
    var carModel: String?
    
    var connectors: [String?]
    var parkingFee: Bool?
    var fastCharge: Bool?
    
    var cloudStorage: Bool?
}
