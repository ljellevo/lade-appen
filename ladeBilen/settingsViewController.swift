//
//  settingsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 11.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import FirebaseAuth

class settingsViewController: UITableViewController {
    
    let sections = ["Søke instillinger", "Bruker", "Utsene", "Om oss"]
    let options = [["Type stasjoner", "Type støpsel", "Eier", "Status"], ["Endre E-Post", "Endre Passord"], ["Flytte knappene"], ["Brukeravtale", "Sammarbeidspartnere"]]
    let settingsOptions = ["Søke instillinger", "Bruker", "Utsene", "Om oss", "Logg ut"]
    
    let defaults = UserDefaults.standard
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = self.settingsOptions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsOptions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            //Naviger til "Søke instillinger"
            print("0")
        } else if (indexPath.row == 1) {
            //Naviger til "Bruker"
            print("1")
        } else if (indexPath.row == 2) {
            //Naviger til "Utsene"
            print("2")
        } else if (indexPath.row == 3) {
            //Naviger til "Om oss"
            print("3")
        } else if (indexPath.row == 4) {
            //Logg ut
            print("4")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedSettings" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destination = segue.destination as! detailedSettingsTableViewController
                destination.selectedRow = indexPath.row
            }
        }
    }
    
    
    
    

}
