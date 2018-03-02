//
//  Algorithms.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

class Algorithms {
    static let database = Database()
    
    
    //General (Run when fetching stations) -> Should be server side
    func checkIfApplicable(station: Station) -> Bool{
        _ = GlobalResources.user?.connector
        for connector in (GlobalResources.user?.connector)! {
            for conn in station.conn {
                if (Int(conn.connector!) != nil) &&  Int(conn.connector!)! == connector {
                    return true
                }
            }
        }
        return false
    }

    
    
    //Favorites/Details
    func findPopularityLevel(station: Station) -> Int{
        return -1
    }
    
    func findSubscribersToStation(station: Station) -> Int{
        return -1
    }
    
    func findAvailableContacts(station: Station) -> [Int]{
        return [-1, -1]
    }
    
    func checkIfAvailable(station: Station) -> Bool{
        return true
    }
    
    func populateFavoritesArray(){
        _ = GlobalResources.favorites
        _ = GlobalResources.stations
    }
    

    

    
    
    
}
