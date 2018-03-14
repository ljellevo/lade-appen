//
//  App.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 06.03.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import Foundation
import Firebase
import Disk

class App {
    let database = DatabaseApp()
    var algorithms = Algorithms()
    let cacheManagement = CacheManagement()
    
    var user: User?
    var stations: [Station] = []
    var filteredStations: [Station] = []
    var favorites: [Int:Int] = [:]
    
    //Initialize
    func initializeApplication(done: @escaping (_ code: Int)-> Void){
        let group = DispatchGroup()
        var verificationCode: Int = -1
        let startDateTotal: NSDate = NSDate()
        
        
        group.enter()
        var startDate: NSDate = NSDate()
        verifyUserCache(){(code: Int?) -> Void in
            let endDate: NSDate = NSDate()
            let timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
            print("User verified: seconds: \(timeInterval)")
            verificationCode = code!
            DispatchQueue.main.async {
                group.leave()
            }
        }

        
        group.enter()
        startDate = NSDate()
        self.verifyStationCache(){
            let endDate: NSDate = NSDate()
            let timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
            print("Stations verified: seconds: \(timeInterval)")
            DispatchQueue.main.async {
                group.leave()
            }
        }
        
        group.enter()
        startDate = NSDate()
        self.verifyFavoritesCache {
            let endDate: NSDate = NSDate()
            let timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
            print("Favorites verified: seconds: \(timeInterval)")
            DispatchQueue.main.async {
                group.leave()
            }
        }
        
        startDate = NSDate()
        group.notify(queue: .main) {
            print("All done")
            self.verifyFilteredStationsCache()
            let endDate: NSDate = NSDate()
            var timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
            print("FilteredStations verified: seconds: \(timeInterval)")
            timeInterval = endDate.timeIntervalSince(startDateTotal as Date)
            print("Done: seconds: \(timeInterval)")
            done(verificationCode)
        }
    }
    
    func verifyStationCache(done: @escaping ()-> Void){
        if let stations = fetchStationCache(){
            self.stations = stations
            done()
        } else {
            print("Stations not cached, fetching from database")
            getStationsFromDatabase {
                done()
            }
        }
    }
    
    private func verifyFilteredStationsCache() {
        if let filteredStations = fetchFilteredStationsCache(){
            self.filteredStations = filteredStations
        } else {
            print("Filtered stations not cached")
            filteredStations = algorithms.filterStations(stations: stations, user: user!)
            _ = self.updateFilteredStationsCache()
        }
    }
    
    private func verifyFavoritesCache(done: @escaping ()-> Void){
        if fetchFavoritesCache() != [-1:-1]{
            favorites = fetchFavoritesCache()
            done()
        } else {
            print("Favorites not cached")
            getFavoritesFromDatabase(){
                done()
            }
        }
    }
    
    func verifyUserCache(done: @escaping (_ code: Int) -> Void){
        if let user = fetchUserCache(){
            self.user = user
            getUserTimestampFromDatabase(done: { timestampReturned in
                let timestamp = timestampReturned
                if user.timestamp == timestamp {
                    done(0)
                } else {
                    print("User cache not verified")
                    self.database.fetchUserFromDatabase(){user in
                        if user != nil {
                            self.user = user
                            _ = self.updateUserCache()
                            done(0)
                        } else {
                            done(1)
                        }
                    }
                }
            })
        } else {
            print("User not cached")
            database.fetchUserFromDatabase(){user in
                if user != nil {
                    self.user = user
                    _ = self.updateUserCache()
                    done(0)
                } else {
                    done(1)
                }
            }
        }
    }
    
    //CacheManagement
    func fetchUserCache() -> User?{
        return cacheManagement.fetchUserCache()
    }
    
    func updateUserCache() -> Bool{
        return cacheManagement.updateUserCache(user: user!)
    }
    
    func fetchStationCache() -> [Station]?{
        return cacheManagement.fetchStationCache()
    }
    
    func updateStationCache() -> Bool{
        return cacheManagement.updateStationCache(stations: stations)
    }
    
    func fetchFilteredStationsCache() -> [Station]?{
        return cacheManagement.fetchFilteredStationsCache()
    }
    
    func updateFilteredStationsCache() -> Bool{
        return cacheManagement.updateFilteredStationsCache(filteredStations: filteredStations)
    }
    
    func fetchFavoritesCache() -> [Int:Int]{
        return cacheManagement.fetchFavoritesCache()
    }
    
    func updateFavoritesCache() -> Bool{
        return cacheManagement.updateFavoriteCache(favorites: favorites)
    }
    
    func removeAllCache() -> Bool{
        return cacheManagement.removeAllCache()
    }
    
    //Database
    func getStationsFromDatabase(done: @escaping ()-> Void){
        database.getStationsFromDatabase(done: { stations in
            self.stations = stations
            _ = self.updateStationCache()
            done()
        })
    }
    
    func getFavoritesFromDatabase(done: @escaping ()-> Void){
        database.getFavoritesFromDatabase { favorites in
            self.favorites = favorites
            _ = self.updateFavoritesCache()
            done()
        }
    }
    
    func addFavoriteToDatabase(stationId: Int, done: @escaping ()-> Void){
        database.addFavoriteToDatabase(id: stationId)
        self.getFavoritesFromDatabase {
            _ = self.updateFavoritesCache()
            done()
        }
    }
    
    func removeFavoriteFromDatabase(stationId: Int, done: @escaping ()-> Void){
        database.removeFavoriteFromDatabase(id: stationId)
        self.getFavoritesFromDatabase {
            _ = self.updateFavoritesCache()
            done()
        }
    }
    
    func updateUserInDatabase(user: User){
        self.user = user
        database.updateUser(user: user)
        _ = updateUserCache()
    }
    
    func updateEmailForUserInDatabase(newEmail: String){
        user!.email = newEmail
        database.updateEmail(newEmail: newEmail)
        _ = updateUserCache()
    }
    
    func updateFirstnameForUserInDatabase(newFirstname: String){
        user!.firstname = newFirstname
        database.updateFirstname(newFirstname: newFirstname)
        _ = updateUserCache()
    }
    
    func updateLastnameForUserInDatabase(newLastname: String){
        user!.lastname = newLastname
        database.updateLastname(newLastname: newLastname)
        _ = updateUserCache()
    }
    
    func updateConnectorForUserInDatabase(connectors: [Int], willFilterStations: Bool){
        user!.connector = connectors
        database.updateConnector(connectors: connectors)
        if willFilterStations{
            findFilteredStations()
        }
    }
    
    private func findFilteredStations(){
        DispatchQueue.global().async {
            self.filteredStations = self.algorithms.filterStations(stations: self.stations, user: self.user!)
            _ = self.updateUserCache()
            _ = self.updateFilteredStationsCache()
        }
    }
    
    func submitBugToDatabase(reportedText: String){
        database.submitBugReport(reportedText: reportedText)
    }
    
    func getUserTimestampFromDatabase(done: @escaping (_ done: Int64)-> Void){
        database.getUserTimestampFromDatabase(done: { timestamp in
            done(timestamp)
        })
    }
    
    //Algorithms
    func findAvailableContacts(station: Station) -> Int{
        return algorithms.findAvailableContacts(station: station, user: user!)
    } 
}
