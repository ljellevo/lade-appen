//
//  Algorithms.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

class Algorithms {

    //General (Run when fetching stations) -> Should be server side
    func checkIfApplicable(station: Station, user: User) -> Bool{
        for connector in (user.connector)! {
            for conn in station.conn {
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
    
    func findAvailableContacts(station: Station, user: User) -> Int{
        var counter: Int = 0
        for conn in station.conn {
            for connector in user.connector!{
                if conn.connector == connector {
                    counter += 1
                }
            }
        }
        return counter
    }
    
    func checkIfConntactIsAppliable(conn: Connector, user: User) -> Bool{
        for connector in user.connector!{
            if conn.connector == connector {
                return true
            }
        }
        return false
    }
    
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
    
    func checkIfAvailable(station: Station) -> Bool{
        return true
    }
    
    func populateFavoritesArray(){

    }
    
    
}
