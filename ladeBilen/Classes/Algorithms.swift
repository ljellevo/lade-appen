//
//  Algorithms.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import MapKit

class Algorithms {
    
    /**
     Function that runs through all stations and checks each station individually
     
     - parameters:
        - stations: Array with station objects
        - user: User object that contains users preferences
     
     - returns:
     Array with stations that is to be shown
     */
    func filterStations(stations: [Station], user: User) -> [Station]{
        var filteredStations: [Station] = []
        for station in stations {
            if checkIfApplicable(station: station, user: user) {
                filteredStations.append(station)
            }
        }
        return filteredStations
    }

    /**
     Determines if station should be shown on map based on users parameters.
     
     - parameters:
        - station: The station that is to be checked
        - user: User object that contains users prefrences
     
     - returns:
     Bool if station is to be shown
    */
    private func checkIfApplicable(station: Station, user: User) -> Bool {
        //Må sjekke med parameterene i user for så i avgjøre om stasjonen skal vises
        
        if !user.parkingFee {
            if station.parkingFee {
                return false
            }
        }
        
        for connector in (user.connector) {
            for conn in station.conn {
                if !user.fastCharge {
                    if conn.chargerMode > 3 {
                        return false
                    }
                }
                
                if conn.connector == connector {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     Determines the popularity level of a realtime station
    
     - parameters:
        - count: Amount of subscribers
     
     - returns:
     String with popularity (Høy, medium, lav)
     
     */
    func findPopularityLevel(count: Int, ammountOfConnectors: Int, amountOfApplicableConnectors: Int) -> popularity {
        //10-2 = 8
        //8 >= 10 * 0,25
        let freeConnectors = ammountOfConnectors - count
        if freeConnectors >= Int((Double(ammountOfConnectors) * 0.75).rounded()) {
            return popularity.low
        } else if freeConnectors <= Int((Double(ammountOfConnectors) * 0.25).rounded()){
           return popularity.high
        }
        return popularity.medium
    }

    
    /**
     Finds amount of connectors that is available and connectors that are applicable
     
     - parameters:
        - station: Station object that contains the connectors
        - user: User object that contains applicable contacts for the user
     
     - returns:
     Array with [Available, Applicable, Total]
     */
    func findAvailableContacts(station: Station, user: User) -> [Int]{
        var counter: [Int] = [0, 0, 0]
        for conn in station.conn {
            for connector in user.connector{
                if conn.connector == connector {
                    if conn.isTaken == 0 && conn.error == 0 {
                        counter[0] += 1
                    } else if conn.error == 0 {
                        counter[1] += 1
                    }
                }
            }
            counter[2] += 1
        }
        return counter
    }
    
    /**
     Checks if connector is applicable for user
     
     - parameters:
        - conn: Connector object that contains the connector
        - user: User object that contains users applicable conntacts
     
     - returns:
     Bool that indicate if this connector is applicable for user
     */
    func checkIfConntactIsAppliable(conn: Connector, user: User) -> Bool{
        for connector in user.connector{
            if conn.connector == connector {
                return true
            }
        }
        return false
    }
    
    /**
     Sorts connectors in so that applicable and vacant is first, then applicable and busy, then applicable and error and last not applicable connectors
     
     - parameters:
        - station: Station object that contains all the stations connectors
        - user: User object that contains the users preference
     
     - returns:
     Array with sorted connectors
     */
    
    func sortConnectors(station: Station, user: User) -> Station{
        var sortedStation = station
        var newArray: [Connector] = []
        var vacantConn: [Connector] = []
        var busyConn: [Connector] = []
        var statusUnknownConn: [Connector] = []
        var errorConn: [Connector] = []
        
        var found = false
        if station.realtimeInfo {
            for conn in station.conn{
                found = false
                for connector in user.connector{
                    if conn.connector == connector {
                        if conn.error != 0 {
                            errorConn.append(conn)
                        } else {
                            if conn.isTaken == 0 {
                                vacantConn.append(conn)
                            } else if conn.isTaken == 1{
                                busyConn.append(conn)
                            } else {
                                statusUnknownConn.append(conn)
                            }
                        }
                        found = true
                    }
                }
                if !found {
                    newArray.append(conn)
                }
            }
            newArray = vacantConn + busyConn + statusUnknownConn + errorConn + newArray
        } else {
            for conn in station.conn{
                found = false
                for connector in user.connector{
                    if conn.connector == connector {
                        newArray.insert(conn, at: 0)
                        found = true
                    }
                }
                if !found {
                    newArray.append(conn)
                }
            }
        }
        
        sortedStation.conn = newArray
        return sortedStation
    }
    
    /* Mangler */
    func checkIfAvailable(station: Station) -> Bool{
        return true
    }
    
    func populateFavoritesArray(){

    }
    
    func getDistanceToStation(station: Station, location: CLLocation) -> Double{
        var position = station.position
        position = position.replacingOccurrences(of: "(", with: "")
        position = position.replacingOccurrences(of: ")", with: "")
        let positionArray = position.components(separatedBy: ",")
        let lat = Double(positionArray[0])! - 0.007
        let lon = Double(positionArray[1])
        let stationCoordinate = CLLocationCoordinate2D(latitude:lat, longitude:lon!)
        let stationLocation = CLLocation(latitude: stationCoordinate.latitude, longitude: stationCoordinate.longitude)
        let distance = stationLocation.distance(from: location)
        return distance
    }
    
    
}
