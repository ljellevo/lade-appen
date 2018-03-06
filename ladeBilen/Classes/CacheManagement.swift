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
    
    func fetchUserCache() -> User?{
        do{
            if Disk.exists((FIRAuth.auth()?.currentUser?.uid)! + ".json", in: .caches) {
                return try Disk.retrieve((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches, as: User.self)
                //return true
            }
        } catch {
            print("User not cached.")
        }
        return nil
    }
    
    func updateUserCache(user: User){
        do {
            try Disk.save(user, to: .caches, as: (FIRAuth.auth()?.currentUser?.uid)! + ".json")
        } catch {
            print("User cache not updated.")
        }
    }
    
    func fetchStationCache() -> [Station]?{
        do {
            if Disk.exists("stations.json", in: .caches) {
                return try Disk.retrieve("stations.json", from: .caches, as: [Station].self)
            }
        } catch {
            print("Stations not cached.")
        }
        return nil
    }
    
    func updateStationCache(stations: [Station]){
        do {
            try Disk.save(stations, to: .caches, as: "stations.json")
        } catch {
            print("Stations cache not updated.")
        }
    }
    
    func fetchFilteredStationsCache() -> [Station]?{
        do {
            if Disk.exists("filteredStations.json", in: .caches) {
                return try Disk.retrieve("filteredStations.json", from: .caches, as: [Station].self)
            }
        } catch {
            print("Filtered Stations not cached.")
        }
        return nil

    }
    
    func updateFilteredStationsCache(filteredStations: [Station]){
        do {
            try Disk.save(filteredStations, to: .caches, as: "filteredStations.json")
        } catch {
            print("Filtered stations cache not updated.")
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
    
    func updateFavoriteCache(favorites: [Int:Int]){
        do {
            try Disk.save(favorites, to: .caches, as: "favorites.json")
        } catch {
            print("Favorite cache not updated.")
        }
    }
    
    func removeAllCache(){
        do {
            try Disk.remove((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches)
            try Disk.remove("stations.json", from: .caches)
            try Disk.remove("favorites.json", from: .caches)
            try Disk.remove("filteredStations.json", from: .caches)
        } catch {
            print("Cache not deleted")
        }
    }
}
