//
//  changeContactPlayground.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 05.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase

class ChangeContact: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var app: App?
    
    
    var connectorString: [String] = []
    var connectorIndex: [Int] = []
    var connector: [Int] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        connector = app!.user!.connector!
        tableView.delegate = self
        tableView.dataSource = self
        getConnectors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Må bare kalle algoritmen og ikke hente alle stasjonene på nytt.
        print("Disapear")
        _ = app!.setConnectorForUserInDatabase(connectors: connector, willFilterStations: true)
    }
    

    
    func getConnectors(){
        //Må puttes i app klassen
        let ref = Database.database().reference()
        ref.child("nobil_database_static").child("connectors").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            for children in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                self.connectorIndex.append(Int(children.key)!)
                self.connectorString.append(children.value as! String)
            }
            self.tableView.reloadData()
        }, withCancel: nil)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectorIndex.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if connector.index(of: connectorIndex[indexPath.row]) != nil {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectorsCells", for: indexPath)
        cell.textLabel?.text = connectorString[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            connector.append(connectorIndex[indexPath.row])
            app!.setConnectorForUserInDatabase(connectors: connector, willFilterStations: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = connector.index(of: connectorIndex[indexPath.row]) {
            connector.remove(at: index)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
            app!.setConnectorForUserInDatabase(connectors: connector, willFilterStations: false)
        }
    }
}
