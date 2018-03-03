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
    
    func fetchUserCache() -> Bool{
        do{
            if Disk.exists((FIRAuth.auth()?.currentUser?.uid)! + ".json", in: .caches) {
                GlobalResources.user = try Disk.retrieve((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches, as: User.self)
                return true
            }
        } catch {
            print("User not cached.")
        }
        return false
    }
    
    func updateUserCache(){
        do {
            try Disk.save(GlobalResources.user, to: .caches, as: (FIRAuth.auth()?.currentUser?.uid)! + ".json")
        } catch {
            print("User cache not updated.")
        }
    }
    
    func fetchStationCache() -> Bool{
        do {
            if Disk.exists("stations.json", in: .caches) {
                GlobalResources.stations = try Disk.retrieve("stations.json", from: .caches, as: [Station].self)
                return true
            }
        } catch {
            print("Stations not cached.")
        }
        return false
    }
    
    func updateStationCache(){
        do {
            try Disk.save(GlobalResources.stations, to: .caches, as: "stations.json")
        } catch {
            print("Stations cache not updated.")
        }
    }
    
    func fetchFilteredStationsCache() -> Bool{
        do {
            if Disk.exists("filteredStations.json", in: .caches) {
                GlobalResources.filteredStations = try Disk.retrieve("filteredStations.json", from: .caches, as: [Station].self)
                return true
            }
        } catch {
            print("Filtered Stations not cached.")
        }
        return false

    }
    
    func updateFilteredStationsCache(){
        do {
            try Disk.save(GlobalResources.filteredStations, to: .caches, as: "filteredStations.json")
        } catch {
            print("Filtered stations cache not updated.")
        }
    }
    
    func fetchFavoritesCache() -> Bool{
        do {
            if Disk.exists("favorites.json", in: .caches){
                GlobalResources.favorites = try Disk.retrieve("favorites.json", from: .caches, as: [Int:Int].self)
                return true
            }
        } catch {
            print("Favorites not cached.")
        }
        return false

    }
    
    func updateFavoriteCache(){
        do {
            try Disk.save(GlobalResources.favorites, to: .caches, as: "favorites.json")
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
