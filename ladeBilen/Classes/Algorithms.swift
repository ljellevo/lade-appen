//
//  Algorithms.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation

class Algorithms {
    let database = Database()
    
    
    //General (Run when fetching stations) -> Should be server side
    func checkIfApplicable(){
        _ = GlobalResources.user?.connector
        _ = GlobalResources.stations
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
