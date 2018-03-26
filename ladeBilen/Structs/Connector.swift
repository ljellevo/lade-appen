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
    var operationStatus: Int64?
    var paymentMethod: String?
    var reservable: String?
    var sensorStatus: String?
    var status: Int64?
    var timestamp: Int64?
    var vehicle: String?
    
    init(dictionary: NSDictionary) {
        self.accesibility = dictionary["Accessibility"] as? String ?? ""
        self.capasity = dictionary["Capacity"] as? String ?? ""
        self.chargerMode = dictionary["ChargeMode"] as? String ?? ""
        self.connector = dictionary["Connector"] as? String ?? ""
        self.fixedCable = dictionary["FixedCable"] as? String ?? ""
        self.manufacturer = dictionary["Manufacturer"] as? String ?? ""
        self.operationStatus = dictionary["OperationStatus"] as? Int64
        self.paymentMethod = dictionary["PaymentMethod"] as? String ?? ""
        self.reservable = dictionary["Reservable"] as? String ?? ""
        self.sensorStatus = dictionary["SensorStatus"] as? String ?? ""
        self.status = dictionary["Status"] as? Int64
        self.timestamp = dictionary["Timestamp"] as? Int64
        self.vehicle = dictionary["Vehicle"] as? String ?? ""
    }
}

