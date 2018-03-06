//
//  Algorithms.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

class Algorithms {
    let user: User?
    let stations: [Station]?
    var filteredStations: [Station]?
    var favorites: [Int:Int] = [:]
    let cacheManagement = CacheManagement()
    
    init(user: User, stations: [Station], filteredStations: [Station], favorites: [Int:Int]) {
        self.user = user
        self.stations = stations
        self.filteredStations = filteredStations
        self.favorites = favorites
    }
    
    //General (Run when fetching stations) -> Should be server side
    func checkIfApplicable(station: Station) -> Bool{
        _ = user?.connector
        for connector in (user?.connector)! {
            for conn in station.conn {
                if (Int(conn.connector!) != nil) &&  Int(conn.connector!)! == connector {
                    return true
                }
            }
        }
        return false
    }
    
    func filterStations(){
        var temp: [Station] = []
        for station in stations! {
            if checkIfApplicable(station: station) {
                temp.append(station)
            }
        }
        filteredStations = temp        
    }

    
    
    //Favorites/Details
    func findPopularityLevel(station: Station) -> Int{
        return -1
    }
    
    func findSubscribersToStation(station: Station) -> Int{
        return -1
    }
    
    func findAvailableContacts(station: Station) -> Int{
        var counter: Int = 0
        for conn in station.conn {
            for connector in user!.connector!{
                if (Int(conn.connector!) != nil) &&  Int(conn.connector!)! == connector {
                    counter += 1
                }
            }
        }
        return counter
    }
    
    func checkIfAvailable(station: Station) -> Bool{
        return true
    }
    
    func populateFavoritesArray(){
        _ = favorites
        _ = stations
    }  
}
