//
//  ConnStruct.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 18.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

struct Connector: Codable {
    var accesibility: String?
    var capasity: String?
    var chargerMode: String?
    var connector: String?
    var fixedCable: String?
    var manufacturer: String?
    var error: Int64?
    var paymentMethod: String?
    var reservable: String?
    var sensorStatus: String?
    var isTaken: Int64?
    var timestamp: Int64?
    var vehicle: String?
    
    init(dictionary: NSDictionary) {
        self.accesibility = dictionary["Accessibility"] as? String ?? ""
        self.capasity = dictionary["Capacity"] as? String ?? ""
        self.chargerMode = dictionary["ChargeMode"] as? String ?? ""
        self.connector = dictionary["Connector"] as? String ?? ""
        self.fixedCable = dictionary["FixedCable"] as? String ?? ""
        self.manufacturer = dictionary["Manufacturer"] as? String ?? ""
        self.error = dictionary["OperationStatus"] as? Int64 ?? 1
        self.paymentMethod = dictionary["PaymentMethod"] as? String ?? ""
        self.reservable = dictionary["Reservable"] as? String ?? ""
        self.sensorStatus = dictionary["SensorStatus"] as? String ?? ""
        self.isTaken = dictionary["Status"] as? Int64 ?? 0
        self.timestamp = dictionary["Timestamp"] as? Int64 ?? 0
        self.vehicle = dictionary["Vehicle"] as? String ?? ""
    }
}

