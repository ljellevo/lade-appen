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
    
    func updateUserCache(){
        do {
            try Disk.save(GlobalResources.user, to: .caches, as: (FIRAuth.auth()?.currentUser?.uid)! + ".json")
        } catch {
            print("User not stored in cache")
        }
    }
    
    func updateStationCache(){
        do {
            try Disk.save(GlobalResources.stations, to: .caches, as: "stations.json")
        } catch {
            print("Station not stored in cache")
        }
    }
    
    func updateFavoriteCache(){
        do {
            try Disk.save(GlobalResources.favorites, to: .caches, as: "favorites.json")
        } catch {
            print("Favorites not stored in cache")
        }
    }
}
