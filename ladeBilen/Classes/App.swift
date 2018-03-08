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
    var algorithms: Algorithms?
    let cacheManagement = CacheManagement()
    
    var user: User?
    var stations: [Station] = []
    var filteredStations: [Station] = []
    var favorites: [Int:Int] = [:]
    
    //Initialize
    func initializeApplication(done: @escaping (_ code: Int)-> Void){
        let group = DispatchGroup()
        var verificationCode: Int = -1
        group.enter()
        verifyUserCache(){(code: Int?) -> Void in
            print("User verified")
            verificationCode = code!
            DispatchQueue.main.async {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("User verified")
            let infoGroup = DispatchGroup()
            
            infoGroup.enter()
            self.verifyStationCache(){
                print("Stations verified")
                DispatchQueue.main.async {
                    infoGroup.leave()
                }
            }
            
            infoGroup.enter()
            self.verifyFavoritesCache {
                print("Favorites verified")
                DispatchQueue.main.async {
                    infoGroup.leave()
                }
            }
            
            infoGroup.notify(queue: .main) {
                print("All done")
                self.verifyFilteredStationsCache()
                self.algorithms = Algorithms(user: self.user!, stations: self.stations, filteredStations: self.filteredStations, favorites: self.favorites)
                done(verificationCode)
            }
        }
    }
    
    func verifyStationCache(done: @escaping ()-> Void){
        if fetchStationCache() != nil {
            stations = fetchStationCache()!
            done()
        } else {
            database.getStationsFromDatabase {_ in 
                done()
            }
        }
    }
    
    private func verifyFilteredStationsCache() {
        if fetchFilteredStationsCache() != nil{
            filteredStations = fetchFilteredStationsCache()!
        } else {
            //Regn ut filtrerte stasjoner
        }
    }
    
    private func verifyFavoritesCache(done: @escaping ()-> Void){
        if fetchFavoritesCache() != [-1:-1] {
            favorites = fetchFavoritesCache()
            done()
        } else {
            database.getFavoritesFromDatabase(){_ in 
                done()
            }
        }
    }
    
    func verifyUserCache(done: @escaping (_ code: Int) -> Void){
        if fetchUserCache() != nil{
            user = fetchUserCache()
            done(0)
        } else {
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
        database.updateUser(user: user)
        _ = updateUserCache()
    }
    
    func updateEmailForUserInDatabase(newEmail: String){
        database.updateEmail(newEmail: newEmail)
    }
    
    func updateFirstnameForUserInDatabase(newFirstname: String){
        database.updateFirstname(newFirstname: newFirstname)
    }
    
    func updateLastnameForUserInDatabase(newLastname: String){
        database.updateLastname(newLastname: newLastname)
    }
    
    func updateConnectorForUserInDatabase(connectors: [Int]){
        database.updateConnector(connectors: connectors)
    }
    
    func submitBugToDatabase(reportedText: String){
        database.submitBugReport(reportedText: reportedText)
    }
    

    

    

    

    
    
}
