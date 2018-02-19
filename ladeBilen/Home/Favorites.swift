//
//  favoritesViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Disk

class Favorites: UITableViewController {

    let database = Database()
    var favoriteArray: [Station] = []
    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFavoritesCache()
    }
    
    func checkFavoritesCache(){
        do {
            if Disk.exists("favorites.json", in: .caches){
                GlobalResources.favorites = try Disk.retrieve("favorites.json", from: .caches, as: [Int].self)
                self.populateFavoritesArray()
            } else {
                database.getFavoritesFromDatabase(){
                    self.populateFavoritesArray()
                }
            }
        } catch {
            database.getFavoritesFromDatabase(){
                self.populateFavoritesArray()
            }
        }
    }
    
    func populateFavoritesArray(){
        for station in GlobalResources.stations{
            for favorite in GlobalResources.favorites{
                if station.id == favorite {
                    self.favoriteArray.append(station)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CellId")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = favoriteArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        station = favoriteArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsFromFavorites", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromFavorites"{
            if let nextViewController = segue.destination as? Details{
                nextViewController.station = station
            }
        }
    }
}
