//
//  Station.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import Foundation

struct Station: Codable {
    var availability: String = ""
    var availableChargingPoints: Int = -1
    var city: String = ""
    var contactInfo: String = ""
    var county: String = ""
    var countyId: String = ""
    var created: String = ""
    var descriptionOfLocation: String = ""
    var houseNumber: String = ""
    var image: String = ""
    var internationalId: String = ""
    var landCode: String = ""
    var location: String = ""
    var municipality: String = ""
    var municipalityId: String = ""
    var numberOfChargingPoints: Int = -1
    var open24h: String = ""
    var ownedBy: String = ""
    var parkingFee: Bool = true
    var position: String = ""
    var publicFounding: String = ""
    var realtimeInfo: Bool = false
    var stationStatus: Int = -1
    var street: String = ""
    var timeLimit: String = ""
    var updated: String = ""
    var userComment: String = ""
    var zipCode: String = ""
    var conn: [Connector] = []
    var id: Int = -1
    var name: String = ""
    
    init(dictionary: [String: AnyObject]) {
        self.availability = dictionary["Availability"] as! String
        self.availableChargingPoints = dictionary["Available_charging_points"] as! Int
        self.city = dictionary["City"] as! String
        self.contactInfo = dictionary["ContactInfo"] as! String
        self.county = dictionary["County"] as! String
        self.countyId = dictionary["CountyID"] as! String
        self.created = dictionary["Created"] as! String
        self.descriptionOfLocation = dictionary["Description_of_location"] as! String
        self.houseNumber = dictionary["HouseNumber"] as! String
        self.image = dictionary["Image"] as! String
        self.internationalId = dictionary["InternationalID"] as! String
        self.landCode = dictionary["LandCode"] as! String
        self.location = dictionary["Location"] as! String
        self.municipality = dictionary["Municipality"] as! String
        self.municipalityId = dictionary["MunicipalityID"] as! String
        self.numberOfChargingPoints = dictionary["NumberCharging_points"] as! Int
        self.open24h = dictionary["Open24h"] as! String
        self.ownedBy = dictionary["OwnedBy"] as! String
        let parkingFee = dictionary["ParkingFee"] as? String ?? ""
        if parkingFee == "Yes" {
            self.parkingFee = true
        } else {
            self.parkingFee = false
        }
        self.position = dictionary["Position"] as! String
        self.publicFounding = dictionary["PublicFunding"] as! String
        let realtime = dictionary["RealtimeInfo"] as? String ?? ""
        if realtime == "Yes" {
            self.realtimeInfo = true
        } else {
            self.realtimeInfo = false
        }
        self.stationStatus = dictionary["StationStatus"] as! Int
        self.street = dictionary["Street"] as! String
        self.timeLimit = dictionary["TimeLimit"] as! String
        self.updated = dictionary["Updated"] as! String
        self.userComment = dictionary["UserComment"] as! String
        self.zipCode = dictionary["Zipcode"] as! String
        self.id = dictionary["id"] as! Int
        self.name = dictionary["name"] as! String
        
        addConnArray(connArray: dictionary["conn"] as! NSArray)
    }
    
    
    
    mutating func addConnArray(connArray: NSArray){
        for i in 1...(connArray.count - 1){
            let connElement = Connector(dictionary: connArray[i] as! NSDictionary)
            self.conn.append(connElement)
        }
    }
}
