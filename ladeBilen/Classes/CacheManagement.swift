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
    
    func getConnectorDescriptionCache() -> [Int:String]?{
        do {
            if Disk.exists(Constants.PATHS.CONNECTOR_DESCRIPTION_PATH, in: .caches) {
                return try Disk.retrieve(Constants.PATHS.CONNECTOR_DESCRIPTION_PATH, from: .caches, as: [Int:String].self)
            }
        } catch {
            print("Connector Descriptions not cached.")
        }
        return nil
    }
    
    func setConnectorDescriptionCache(connectorDescription: [Int:String]) -> Bool {
        do {
            try Disk.save(connectorDescription, to: .caches, as: Constants.PATHS.CONNECTOR_DESCRIPTION_PATH)
            return true
        } catch {
            print("Connector Descriptions cache not updated.")
            return false
        }
    }
    
    /*
    func getImageUrlCache() -> [ImageURL]? {
        do {
            if Disk.exists(Constants.PATHS.IMAGEURL_CACHE_PATH, in: .caches) {
                return try Disk.retrieve(Constants.PATHS.IMAGEURL_CACHE_PATH, from: .caches, as: [ImageURL].self)
            }
        } catch {
            print("Image URL not cached")
        }
        return nil
    }
    
    func setImageUrlCache(imageUrls: [ImageURL]) -> Bool{
        do {
            try Disk.save(imageUrls, to: .caches, as: Constants.PATHS.IMAGEURL_CACHE_PATH)
            return true
        } catch {
            print("Image URL not saved")
            return false
        }
    }
 */
    
    func getImageFromCache(stationId: String) -> UIImage? {
        do {
            return try Disk.retrieve("photos/station/" + stationId + "/station.jpg", from: .documents, as: UIImage.self)
        } catch {
            print("Image not found in cache")
        }
        return nil
    }
    
    func setImageInCache(stationId: String, image: UIImage) -> Bool{
        do {
            try Disk.save(image, to: .documents, as: "photos/station/" + stationId + "/station.jpg")
            return true
        } catch {
            print("Image not cached")
            return false
        }
    }

    
    func removeAllCache() -> Bool{
        do {
            try Disk.remove(Constants.PATHS.USER_CACHE_PATH, from: .caches)
            try Disk.remove(Constants.PATHS.STATION_CACHE_PATH, from: .caches)
            try Disk.remove(Constants.PATHS.FILTERED_STATION_CACHE, from: .caches)
            try Disk.remove(Constants.PATHS.IMAGEURL_CACHE_PATH, from: .caches)
            try Disk.remove(Constants.PATHS.CONNECTOR_DESCRIPTION_PATH, from: .caches)
            return true
        } catch {
            print("Cache not deleted")
        }
        return false
    }
}
