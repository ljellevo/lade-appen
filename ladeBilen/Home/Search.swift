//
//  searchViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 11.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class Search: UITableViewController, UISearchResultsUpdating {

    
    
    let database = Database()
    var filteredStations: [Station]?

    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        if GlobalResources.stations.count == 0 {
            print("No stations")
            database.getStationsFromDatabase {
                print("Refresh")
                self.tableView.reloadData()
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = filteredStations else {
            return GlobalResources.stations.count
        }
        return result.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationsCells", for: indexPath)
        
        if let result = filteredStations {
            cell.textLabel!.text = result[indexPath.row].name
        } else {
            cell.textLabel!.text = GlobalResources.stations[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredStations = GlobalResources.stations.filter { filteredStations in
                return (filteredStations.name?.lowercased().contains(searchText.lowercased()))!
            }
            
        } else {
            filteredStations = GlobalResources.stations
        }
        tableView.reloadData()
    }
}
