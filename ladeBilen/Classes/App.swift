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
    private let database = DatabaseApp()
    private var algorithms = Algorithms()
    private let cacheManagement = CacheManagement()
    
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
    
    
}

private typealias AuthenticationMethods = App
extension AuthenticationMethods {
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
}

private typealias CacheManagementMethods = App
extension CacheManagementMethods {
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
}

private typealias DatabaseMethods = App
extension DatabaseMethods {
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
    
    func listenOnStation(stationId: Int, done: @escaping (_ station: Station)-> Void){
        database.listenOnStation(stationId: getStationIdAsString(stationId: stationId)) { conns in
            DispatchQueue.global().async {
                if var station = self.findStationWith(id: stationId) {
                    for i in 0..<station.conn.count {
                        let conn = conns[i + 1] as! [String : AnyObject]
                        station.conn[i].error = conn["Error"] as? Int64
                        station.conn[i].isTaken = conn["Status"] as? Int64
                        station.conn[i].timestamp = conn["Timestamp"] as? Int64
                    }
                    self.filteredStations = self.algorithms.filterStations(stations: self.stations, user: self.user!)
                    self.updateStation(updatedStation: station)
                    _ = self.setFilteredStationsCache()
                    print("Update App")
                    DispatchQueue.main.async {
                        done(station)
                    }
                }
            }
        }
    }
    
    func detachListenerOnStation(stationId: Int){
        database.detatchListenerOnStation(stationId: getStationIdAsString(stationId: stationId))
    }
}

private typealias AlgorithmsMethods = App
extension AlgorithmsMethods {
    func findAvailableContacts(station: Station) -> Int{
        return algorithms.findAvailableContacts(station: station, user: user!)
    }
    
    func checkIfConntactIsAppliable(connector: Connector) -> Bool {
        return algorithms.checkIfConntactIsAppliable(conn: connector, user: user!)
    }
    
    func updateStation(updatedStation: Station){
        for i in 0..<stations.count {
            if stations[i].id == updatedStation.id {
                stations[i] = updatedStation
                _ = setStationCache()
                return
            }
        }
    }
    
    func sortConnectors(station: Station) -> Station{
        return algorithms.sortConnectors(station: station, user: user!)
    }
    
    func findStationWith(id: Int) -> Station? {
        for station in stations {
            if station.id == id {
                return station
            }
        }
        return nil
    }
    
    func getStationIdAsString(stationId: Int) -> String{
        var stationIdString: String = ""
        if stationId < 10 {
            stationIdString = "NOR_0000" + stationId.description
            //Mindre en 10
        } else if stationId < 100 {
            stationIdString = "NOR_000" + stationId.description
            //Mindre en 100
        } else if stationId < 1000 {
            stationIdString = "NOR_00" + stationId.description
            //Mindre en 1000
        } else if stationId < 10000 {
            stationIdString = "NOR_0" + stationId.description
            //Mindre en 10000
        } else {
            stationIdString = "NOR_" + stationId.description
        }
        return stationIdString
    }
}
