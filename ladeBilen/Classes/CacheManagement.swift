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
            if Disk.exists((Auth.auth().currentUser?.uid)! + ".json", in: .caches) {
                return try Disk.retrieve((Auth.auth().currentUser?.uid)! + ".json", from: .caches, as: User.self)
                //return true
            }
        } catch {
            print("User not cached.")
        }
        return nil
    }
    
    func setUserCache(user: User) -> Bool{
        do {
            try Disk.save(user, to: .caches, as: (Auth.auth().currentUser?.uid)! + ".json")
            return true
        } catch {
            print("User cache not updated.")
            return false
        }
    }
    
    func getStationCache() -> [Station]?{
        do {
            if Disk.exists("stations.json", in: .caches) {
                return try Disk.retrieve("stations.json", from: .caches, as: [Station].self)
            }
        } catch {
            print("Stations not cached.")
        }
        return nil
    }
    
    func setStationCache(stations: [Station]) -> Bool{
        do {
            try Disk.save(stations, to: .caches, as: "stations.json")
            return true
        } catch {
            print("Stations cache not updated.")
            return false
        }
    }
    
    func getFilteredStationsCache() -> [Station]?{
        do {
            if Disk.exists("filteredStations.json", in: .caches) {
                return try Disk.retrieve("filteredStations.json", from: .caches, as: [Station].self)
            }
        } catch {
            print("Filtered Stations not cached.")
        }
        return nil

    }
    
    func setFilteredStationsCache(filteredStations: [Station]) -> Bool{
        do {
            try Disk.save(filteredStations, to: .caches, as: "filteredStations.json")
            return true
        } catch {
            print("Filtered stations cache not updated.")
            return false
        }
    }
    
    func fetchFavoritesCache() -> [Int:Int]{
        do {
            if Disk.exists("favorites.json", in: .caches){
                return try Disk.retrieve("favorites.json", from: .caches, as: [Int:Int].self)
            }
        } catch {
            print("Favorites not cached.")
        }
        return [-1:-1]

    }
    
    func updateFavoriteCache(favorites: [Int:Int]) -> Bool{
        do {
            try Disk.save(favorites, to: .caches, as: "favorites.json")
            return true
        } catch {
            print("Favorite cache not updated.")
            return false
        }
    }
    
    func removeAllCache() -> Bool{
        do {
            try Disk.remove((Auth.auth().currentUser?.uid)! + ".json", from: .caches)
            try Disk.remove("stations.json", from: .caches)
            try Disk.remove("favorites.json", from: .caches)
            try Disk.remove("filteredStations.json", from: .caches)
            return true
        } catch {
            print("Cache not deleted")
        }
        return false
    }
}
