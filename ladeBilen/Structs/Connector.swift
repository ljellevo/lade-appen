//
//  ConnStruct.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 18.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

struct Connector: Codable {
    var accesibility: String = ""
    var capasity: Int = -1
    var chargerMode: Int = -1
    var connector: Int = -1
    var fixedCable: String = ""
    var manufacturer: String = ""
    var error: Int = -1
    var paymentMethod: String = ""
    var reservable: String = ""
    var sensorStatus: String = ""
    var isTaken: Int = -1
    var timestamp: Int64 = -1
    var vehicle: String = ""
    
    init(dictionary: NSDictionary) {
        self.accesibility = dictionary["Accessibility"] as? String ?? ""
        self.capasity = dictionary["Capacity"] as? Int ?? -1
        self.chargerMode = dictionary["ChargeMode"] as? Int ?? -1
        self.connector = dictionary["Connector"] as? Int ?? -1
        self.fixedCable = dictionary["FixedCable"] as? String ?? ""
        self.manufacturer = dictionary["Manufacturer"] as? String ?? ""
        self.error = dictionary["OperationStatus"] as? Int ?? -1
        self.paymentMethod = dictionary["PaymentMethod"] as? String ?? ""
        self.reservable = dictionary["Reservable"] as? String ?? ""
        self.sensorStatus = dictionary["SensorStatus"] as? String ?? ""
        self.isTaken = dictionary["Status"] as? Int ?? -1
        self.timestamp = dictionary["Timestamp"] as? Int64 ?? -1
        self.vehicle = dictionary["Vehicle"] as? String ?? ""
    }
}

