//
//  RegisterFinished.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import Disk
import AudioToolbox

class RegisterFinished: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var connectorString: [String] = []
    var connectorIndex: [Int] = []
    
    var uid: String?
    var email: String?
    var firstname: String?
    var lastname: String?
    var fastcharge: Bool?
    var parkingfee: Bool?
    var cloudStorage: Bool?
    var notifications: Bool?
    var notificationsDuration: Int?
    var connector: [Int] = []
    var connectorIndexPath: IndexPath?
    var connectorSelected: Bool = false
    
    let database = Database()
    
    @IBOutlet weak var whitePannel: UIView!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whitePannel.layer.cornerRadius = 20
        finishedButton.layer.cornerRadius = 20
        tableView.delegate = self
        tableView.dataSource = self
        getConnectors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if connector.index(of: connectorIndex[indexPath.row]) != nil {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
    }
 */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectorsCells", for: indexPath)
        cell.textLabel?.text = connectorString[indexPath.row]
        cell.selectionStyle = .none
        if connector.index(of: connectorIndex[indexPath.row]) != nil {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                connector.append(connectorIndex[indexPath.row])
            }
            print(connector)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = connector.index(of: connectorIndex[indexPath.row]) {
            connector.remove(at: index)
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                }
            }
        }
        print(connector)
    }
    
    @IBAction func finishedButton(_ sender: UIButton) {
        if connector.count != 0 {
            let user = User(uid: uid!, email: email!, firstname: firstname!, lastname: lastname!, fastCharge: fastcharge!, parkingFee: parkingfee!, cloudStorage: cloudStorage!, notifications: notifications!, notificationDuration: notificationsDuration!, connector: connector)
            GlobalResources.user = user
            database.updateUser()
            do {
                if Disk.exists("stations.json", in: .caches) {
                    GlobalResources.stations = try Disk.retrieve("stations.json", from: .caches, as: [Station].self)
                    print("Stations is cached")
                    performSegue(withIdentifier: "toHomeFromRegister", sender: self)
                } else {
                    print("Could not find stations cache, asking database")
                    database.getStationsFromDatabase {
                        self.performSegue(withIdentifier: "toHomeFromRegister", sender: self)
                    }
                }
            } catch {
                print("Could not retrieve stations cache, asking database")
                database.getStationsFromDatabase {
                    self.performSegue(withIdentifier: "toHomeFromRegister", sender: self)
                }
            }
        } else {
          AudioServicesPlaySystemSound(Constants.VIBRATION_WEAK)
        }
    }
}
