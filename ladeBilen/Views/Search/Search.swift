//
//  searchViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 11.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

/*
import UIKit

class Search: UITableViewController, UISearchResultsUpdating {

    let database = Database()
    var filteredStations: [Station]?
    var index: Int?
    var searchText: String?

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
            database.getStationsFromDatabase {_ in 
                print("Refresh")
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let text = searchText {
            searchController.searchBar.text = text
        } else {
            searchController.searchBar.text = ""
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.definesPresentationContext = true
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchText = searchController.searchBar.text
        searchController.searchBar.text = ""
        searchController.dismiss(animated: false, completion: nil)
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
        index = indexPath.row
        performSegue(withIdentifier: "toDetailsFromSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if filteredStations != nil {
            if let nextViewController = segue.destination as? Details{
                nextViewController.station = filteredStations![index!]
            }
        } else {
            if let nextViewController = segue.destination as? Details{
                nextViewController.station = GlobalResources.stations[index!]
            }
        }
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
 */
