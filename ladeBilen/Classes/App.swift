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
        if let stations = getStationCache(){
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
        if let filteredStations = getFilteredStationsCache(){
            self.filteredStations = filteredStations
        } else {
            print("Filtered stations not cached")
            filteredStations = algorithms.filterStations(stations: stations, user: user!)
            _ = self.setFilteredStationsCache()
        }
    }
    
    
    
    func verifyUserCache(done: @escaping (_ code: Int) -> Void){
        if let user = getUserCache(){
            self.user = user
            getUserTimestampFromDatabase(done: { timestampReturned in
                let timestamp = timestampReturned
                if user.timestamp == timestamp {
                    done(0)
                } else {
                    print("User cache not verified")
                    self.database.getUserFromDatabase(){user in
                        if user != nil {
                            self.user = user
                            _ = self.setUserCache()
                            done(0)
                        } else {
                            done(1)
                        }
                    }
                }
            })
        } else {
            print("User not cached")
            database.getUserFromDatabase(){user in
                if user != nil {
                    self.user = user
                    _ = self.setUserCache()
                    done(0)
                } else {
                    done(1)
                }
            }
        }
    }
    
    //CacheManagement
    func getUserCache() -> User?{
        return cacheManagement.getUserCache()
    }
    
    func setUserCache() -> Bool{
        return cacheManagement.setUserCache(user: user!)
    }
    
    func getStationCache() -> [Station]?{
        return cacheManagement.getStationCache()
    }
    
    func setStationCache() -> Bool{
        return cacheManagement.setStationCache(stations: stations)
    }
    
    func getFilteredStationsCache() -> [Station]?{
        return cacheManagement.getFilteredStationsCache()
    }
    
    func setFilteredStationsCache() -> Bool{
        return cacheManagement.setFilteredStationsCache(filteredStations: filteredStations)
    }
    
    func removeAllCache() -> Bool{
        return cacheManagement.removeAllCache()
    }
    
    //Database
    func getStationsFromDatabase(done: @escaping ()-> Void){
        database.getStationsFromDatabase(done: { stations in
            self.stations = stations
            _ = self.setStationCache()
            done()
        })
    }
    
    func setUserInDatabase(user: User){
        self.user = user
        self.user!.timestamp = Date().getTimestamp()
        database.setUserInDatabase(user: self.user!)
        _ = setUserCache()
    }
    
    func setConnectorForUserInDatabase(connectors: [Int], willFilterStations: Bool){
        self.user!.connector = connectors
        self.user!.timestamp = Date().getTimestamp()

        database.setUserInDatabase(user: self.user!)
        _ = setUserCache()
        if willFilterStations{
            findFilteredStations()
        }
    }
    
    private func findFilteredStations(){
        DispatchQueue.global().async {
            self.filteredStations = self.algorithms.filterStations(stations: self.stations, user: self.user!)
            _ = self.setUserCache()
            _ = self.setFilteredStationsCache()
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
