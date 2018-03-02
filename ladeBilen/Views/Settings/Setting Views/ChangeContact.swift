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
    
    let database = Database()
    
    var connectorString: [String] = []
    var connectorIndex: [Int] = []
    var connector: [Int] = GlobalResources.user!.connector!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getConnectors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Må bare kalle algoritmen og ikke hente alle stasjonene på nytt.
        database.getStationsFromDatabase {}
    }
    

    
    func getConnectors(){
        let ref = FIRDatabase.database().reference()
        ref.child("nobil_database_static").child("connectors").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            for children in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
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
            GlobalResources.user?.connector = connector
            database.updateConnector()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = connector.index(of: connectorIndex[indexPath.row]) {
            connector.remove(at: index)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
            GlobalResources.user?.connector = connector
            database.updateConnector()
        }
    }
}
