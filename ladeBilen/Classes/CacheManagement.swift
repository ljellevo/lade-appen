//
//  CacheManagement.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import Firebase
import Disk

class CacheManagement {
    
    func getUserCache() -> User?{
        do{
            if Disk.exists(Constants.PATHS.USER_CACHE_PATH, in: .caches) {
                return try Disk.retrieve(Constants.PATHS.USER_CACHE_PATH, from: .caches, as: User.self)
            }
        } catch {
            print("User not cached.")
        }
        return nil
    }
    
    func setUserCache(user: User) -> Bool{
        do {
            try Disk.save(user, to: .caches, as: Constants.PATHS.USER_CACHE_PATH)
            return true
        } catch {
            print("User cache not updated.")
            return false
        }
    }
    
    func getStationCache() -> [Station]?{
        do {
            if Disk.exists(Constants.PATHS.STATION_CACHE_PATH, in: .caches) {
                return try Disk.retrieve(Constants.PATHS.STATION_CACHE_PATH, from: .caches, as: [Station].self)
            }
        } catch {
            print("Stations not cached.")
        }
        return nil
    }
    
    func setStationCache(stations: [Station]) -> Bool{
        do {
            try Disk.save(stations, to: .caches, as: Constants.PATHS.STATION_CACHE_PATH)
            return true
        } catch {
            print("Stations cache not updated.")
            return false
        }
    }
    
    func getFilteredStationsCache() -> [Station]?{
        do {
            if Disk.exists(Constants.PATHS.FILTERED_STATION_CACHE, in: .caches) {
                return try Disk.retrieve(Constants.PATHS.FILTERED_STATION_CACHE, from: .caches, as: [Station].self)
            }
        } catch {
            print("Filtered Stations not cached.")
        }
        return nil

    }
    
    func setFilteredStationsCache(filteredStations: [Station]) -> Bool{
        do {
            try Disk.save(filteredStations, to: .caches, as: Constants.PATHS.FILTERED_STATION_CACHE)
            return true
        } catch {
            print("Filtered stations cache not updated.")
            return false
        }
    }
    

    
    func removeAllCache() -> Bool{
        do {
            try Disk.remove(Constants.PATHS.USER_CACHE_PATH, from: .caches)
            try Disk.remove(Constants.PATHS.STATION_CACHE_PATH, from: .caches)
            try Disk.remove(Constants.PATHS.FILTERED_STATION_CACHE, from: .caches)
            return true
        } catch {
            print("Cache not deleted")
        }
        return false
    }
}
