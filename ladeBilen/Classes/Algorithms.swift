//
//  Algorithms.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

class Algorithms {

    func checkIfApplicable(station: Station, user: User) -> Bool {
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
    
    func filterStations(stations: [Station], user: User) -> [Station]{
        var filteredStations: [Station] = []
        for station in stations {
            if checkIfApplicable(station: station, user: user) {
                filteredStations.append(station)
            }
        }
        return filteredStations
    }

    
    
    //Favorites/Details
    func findPopularityLevel(station: Station) -> Int{
        return -1
    }
    
    func findSubscribersToStation(station: Station) -> Int{
        return -1
    }
    
    //Returns array with [Available, Applicable]
    func findAvailableContacts(station: Station, user: User) -> [Int]{
        var counter: [Int] = [0, 0]
        for conn in station.conn {
            for connector in user.connector{
                if conn.connector == connector {
                    if conn.isTaken == 0 {
                        counter[0] += 1
                    }
                    counter[1] += 1
                }
            }
        }
        return counter
    }
    
    func checkIfConntactIsAppliable(conn: Connector, user: User) -> Bool{
        for connector in user.connector{
            if conn.connector == connector {
                return true
            }
        }
        return false
    }
    
    //Sorts connectros applicable to user first in array
    func sortConnectors(station: Station, user: User) -> Station{
        var sortedStation = station
        var newArray: [Connector] = []
        var vacantConn: [Connector] = []
        var busyConn: [Connector] = []
        var errorConn: [Connector] = []
        
        var found = false
        if station.realtimeInfo {
            for conn in station.conn{
                found = false
                for connector in user.connector{
                    if conn.connector == connector {
                        if conn.isTaken == 0 {
                            vacantConn.append(conn)
                        } else if conn.isTaken == 1 {
                            busyConn.append(conn)
                        } else {
                            errorConn.append(conn)
                        }
                        found = true
                    }
                }
                if !found {
                    newArray.append(conn)
                }
            }
            newArray = vacantConn + busyConn + errorConn + newArray
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
    /*
    func sortConnectors(connectors: [Connector], user: User) -> [Connector]{
        var newArray: [Connector] = []
        
        var found = false
        for conn in connectors{
            found = false
            for connector in user.connector!{
                if conn.connector == connector {
                    newArray.insert(conn, at: 0)
                    found = true
                }
            }
            if !found {
                newArray.append(conn)
            }
        }
        return newArray
    }
    */
    
    /* Mangler */
    func checkIfAvailable(station: Station) -> Bool{
        return true
    }
    
    func populateFavoritesArray(){

    }
    
    
}
