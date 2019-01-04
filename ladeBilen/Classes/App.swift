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
    private let algorithms = Algorithms()
    private let cacheManagement = CacheManagement()
    private let imageManager = ImageManager()
    
    var checksum: Checksum?
    var user: User?
    var stations: [Station] = []
    var filteredStations: [Station] = []
    var connectorDescription: [Int: String] = [:]
    var subscriptions: [Subscription] = []
    
    /**
     Checks if data is available in cache, if not then it fetches from database before app i loaded.
     
     
     Parameter:
     - done: Callback(Status code).
     
     Returns
     - Void.
     */
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
            startDate = NSDate()
//            self.getSubscriptionsFromDatabase(){
//                let endDate: NSDate = NSDate()
//                let timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
//                print("Subscriptions fetched in : \(timeInterval)")
//                DispatchQueue.main.async {
//                    group.leave()
//                }
//            }
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
        self.verifyConnectorDescriptionCache(){
            let endDate: NSDate = NSDate()
            let timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
            print("Connector descriptions verified: seconds: \(timeInterval)")
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
            self.getStationsFromDatabase{}
            
        }
    }
    
    
}

private typealias AuthenticationMethods = App
extension AuthenticationMethods {
    /**
     Tries to load stations from cache, if stations is not cached or something went wron then it fetches from database.
     
     Parameters:
     - done: Callback(Void)
     
     Returns:
     - Void
     */
    func verifyStationCache(done: @escaping ()-> Void){
        if let checksum = getStationCehcksumCache() {
            getStationChecksumFromDatabase {
                if checksum.value == self.checksum!.value {
                    //Local checksum and remote checksum is equal
                    if let stations = self.getStationCache(){
                        self.stations = stations
                        done()
                    } else {
                        print("Stations not cached, fetching from database")
                        self.getStationsFromDatabase {
                            done()
                        }
                    }
                } else {
                    self.getStationsFromDatabase {
                        done()
                    }
                }
            }
        } else {
            self.getStationsFromDatabase {
                done()
            }
        }
        
        /*
        if let stations = getStationCache(){
            self.stations = stations
            done()
        } else {
            print("Stations not cached, fetching from database")
            getStationsFromDatabase {
                done()
            }
        }
 */
    }
    
    /**
     Tries to laod filtered stations from cache, if cache does noit exist or something went wrong it fetches from database.
     
     Parameters:
     - none
     
     Returns:
     - Void
     */
    
    private func verifyFilteredStationsCache() {
        if let filteredStations = getFilteredStationsCache(){
            self.filteredStations = filteredStations
        } else {
            print("Filtered stations not cached")
            filteredStations = algorithms.filterStations(stations: stations, user: user!)
            _ = self.setFilteredStationsCache()
        }
    }
    
    /**
     Tries to load a dict with connector id: connector string from cache. If it is not found it fetches from database.
     
     Parameters:
     - done: Callback(Void)
     
     Returns:
     - Void
     */
    
    private func verifyConnectorDescriptionCache(done: @escaping ()-> Void) {
        if let connectorDescription = getConnectorDescriptionCache(){
            self.connectorDescription = connectorDescription
            done()
        } else {
            print("Connector descriptions not cached, fetching from database")
            getConnectorDescriptionFromDatabase {
                done()
            }
        }
    }
    
    /**
     Tries to load user from cache, if this does not work then it fetches from database.
     
     Parameters:
     - done: Callback(Status code)
     
     Returns:
     - void:
     */
    
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
    
    //Need to guard against nil.

    func getUserCache() -> User?{
        return cacheManagement.getUserCache()
    }
    
    func setUserCache() -> Bool{
        return cacheManagement.setUserCache(user: self.user!)
    }
    
    func getStationCache() -> [Station]?{
        return cacheManagement.getStationCache()
    }

    func setStationCache() -> Bool{
        return cacheManagement.setStationCache(stations: self.stations)
    }
    
    func getStationCehcksumCache() -> Checksum? {
        return cacheManagement.getStationChecksumCache()
    }
    
    func setStationChecksumCache() -> Bool {
        return cacheManagement.setStationChecksumCache(checksum: self.checksum!)
    }
    
    func getFilteredStationsCache() -> [Station]?{
        return cacheManagement.getFilteredStationsCache()
    }

    func setFilteredStationsCache() -> Bool{
        return cacheManagement.setFilteredStationsCache(filteredStations: self.filteredStations)
    }
    
    func getConnectorDescriptionCache() -> [Int:String]?{
        return cacheManagement.getConnectorDescriptionCache()
    }
    
    func setConnectorDescriptionCache() -> Bool{
        return cacheManagement.setConnectorDescriptionCache(connectorDescription: self.connectorDescription)
    }
    
    /*
    func getImageUrlCache() -> [ImageURL] {
        if let cachedImageURls = cacheManagement.getImageUrlCache() {
            return cachedImageURls
        }
        return []
    }
    
    
    func setImageUrlCache() -> Bool {
        return cacheManagement.setImageUrlCache(imageUrls: self.imageUrls)
    }
 */
    
    func removeAllCache() -> Bool{
        return cacheManagement.removeAllCache()
    }
 
    func getImageFromCache(stationId: String) -> UIImage?{
        if let image = cacheManagement.getImageFromCache(stationId: stationId) {
            return image
        }
        return nil
    }
    
    func setImageInCache(stationId: String, image: UIImage) -> Bool {
        return cacheManagement.setImageInCache(stationId: stationId, image: image)
    }
}

private typealias DatabaseMethods = App
extension DatabaseMethods {
    func getStationsFromDatabase(done: @escaping ()-> Void){
        database.getStationChecksumFromDatabase(done: { checksum in
            self.checksum = checksum
            _ = self.setStationChecksumCache()
            self.database.getStationsFromDatabase(done: { stations in
                self.stations = stations
                _ = self.setStationCache()
                print("Got new stations")
                done()
            })
        })
        
    }
    
    func getStationChecksumFromDatabase(done: @escaping ()-> Void) {
        database.getStationChecksumFromDatabase(done: { checksum in
            self.checksum = checksum
            _ = self.setStationChecksumCache()
            done()
        })
    }
    
    func getConnectorDescriptionFromDatabase(done: @escaping ()-> Void){
        database.getConnectorDescriptionFromDatabase(done: { connectorDescription in
            self.connectorDescription = connectorDescription
            _ = self.setConnectorDescriptionCache()
            done()
        })
    }
    
    func setUserInDatabase(user: User, done: @escaping (_ code: Int)-> Void){
        self.user = user
        self.user!.timestamp = Date().getTimestamp()
        database.setUserInDatabase(user: self.user!, done: { code in
            done(code)
        })
        _ = setUserCache()
    }
    
    func setConnectorForUserInDatabase(connectors: [Int], willFilterStations: Bool){
        self.user!.connector = connectors
        self.user!.timestamp = Date().getTimestamp()
        
        database.setUserInDatabase(user: self.user!, done: { _ in })
        _ = setUserCache()
        if willFilterStations{
            findFilteredStations()
        }
    }
    
    func findFilteredStations(){
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
                        station.conn[i].error = conn["Error"] as! Int
                        station.conn[i].isTaken = conn["Status"] as! Int
                        station.conn[i].timestamp = conn["Timestamp"] as! Int64
                    }
                    self.updateStation(updatedStation: station)
                    self.filteredStations = self.algorithms.filterStations(stations: self.stations, user: self.user!)
                    _ = self.setFilteredStationsCache()
                    DispatchQueue.main.async {
                        done(station)
                    }
                }
            }
        }
    }
    
    func subscribeToStation(station: Station, done: @escaping (_ code: Int)-> Void){
        let newSubscription = Subscription(values: ["update": Date().getTimestamp(),
                                                    "from": Date().getTimestamp(),
                                                    "to": (Date().getTimestamp() + Int64(self.user!.notificationDuration * 60))],
                                           key: getStationIdAsString(stationId: station.id))
        self.subscriptions.append(newSubscription)
        database.subscribeToStation(stationId: getStationIdAsString(stationId: station.id), user: self.user!, done: { code in
            done(code)
        })
    }
    
    func unsubscribeToStation(station: Station, done: @escaping (_ code: Int)-> Void){
        for i in 0..<subscriptions.count {
            if subscriptions[i].id == getStationIdAsString(stationId: station.id){
                subscriptions.remove(at: i)
            }
        }
        database.unsubscribeToStation(stationId: getStationIdAsString(stationId: station.id), user: self.user!, done:{ code in
            done(code)
        })
    }
    
    func getSubscriptionsFromDatabase(done: @escaping ()-> Void){
        database.getSubscriptionsFromDatabase(user: self.user!){ subscriptions in
            self.subscriptions = subscriptions
            done()
        }
    }
    
    func detachListenerOnStation(stationId: Int){
        database.detatchListenerOnStation(stationId: getStationIdAsString(stationId: stationId))
    }
    
    func detatchAllListeners(){
        //All stations
        database.detatchAllListeners()
    }
}

private typealias AlgorithmsMethods = App
extension AlgorithmsMethods {
    func findAvailableContacts(station: Station) -> [Int]{
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
    
    func getStationIdFromString(stationId: String) -> Int{
        let stationInt = Int(stationId.replacingOccurrences(of: "NOR_", with: ""))
        return stationInt!
    }
    
    func isStationSubscribedTo(stationId: Int) -> Bool{
        let id = getStationIdAsString(stationId: stationId)
        for sub in subscriptions {
            if sub.id == id {
                return true
            }
        }
        return false
    }
    
    func findSubscription(stationId: Int) -> Subscription?{
        let id = getStationIdAsString(stationId: stationId)
        for sub in subscriptions {
            if sub.id == id {
                return sub
            }
        }
        return nil
    }
}

private typealias ImageMethods = App
extension ImageMethods {
    /**
     Checks if image is cached, if not then fetches from Firebase Storage.
     
     - Parameter station: The station object
     - Parameter url: Returns a callback with url in local filetree
     
     - Returns: Callback when image url is ready. Return value is optional and must bechecked for nil.
     */
    func getImageForStation(station: Station, done: @escaping (_ image: UIImage?)-> Void){
        //Check if image exists
        /*
        for imageUrl in imageUrls {
            if imageUrl.id == station.id {
                done(imageUrl.url)
            }
        }
        
        //Fetch and add url to object
        imageManager.getImageForStation(stationId: getStationIdAsString(stationId: station.id)) { (url, code) in
            if code == 0 {
                let imageUrl = ImageURL(id: station.id, url: url!)
                self.imageUrls.append(imageUrl)
                _ = self.setImageUrlCache()
                done(url!)
            } else {
                done(nil)
            }
        }
 */
        let stationId = getStationIdAsString(stationId: station.id)
        //Check if image exists
        if let image = getImageFromCache(stationId: stationId) {
            print("Image found in cache")
            done(image)
            return
        }
        
        //Fetch image, return and cache
        
        imageManager.getImageForStation(stationId: stationId) { (image, code) in
            if code == 0 {
                _ = self.setImageInCache(stationId: stationId, image: image!)
                print("Image fetched from storage")
                done(image)
                return
            } else {
                done(nil)
                return
            }
            
        }
    }
}
