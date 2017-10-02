//
//  detailedSettingsTableViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 18.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class detailedSettingsTableViewController: UITableViewController {
    
    var selectedRow: Int = 100
    let searchSettingsOptions = ["Type stasjoner", "Type støpsel", "Eier", "Status"]
    let userOptions = ["Endre E-Post", "Endre Passord"]
    let appearanceOptions = ["Flytte knappene"]
    let aboutOptions = ["Brukeravtale", "Sammarbeidspartnere", "Kontakt oss", "Rapporter feil"]
    var options: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedTable()
        print(selectedRow)
        

    }
    
    func setSelectedTable(){
        if (selectedRow == 0){
            options = searchSettingsOptions
        } else if (selectedRow == 1) {
            options = userOptions
        } else if (selectedRow == 2) {
            options = appearanceOptions
        } else if (selectedRow == 3) {
            options = aboutOptions
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedSettingsCell", for: indexPath)
        cell.textLabel?.text = self.options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectedRow == 0) {
            if (indexPath.row == 0) {
                //Type statjoner
            } else if (indexPath.row == 1) {
                //Type støpsel
            } else if (indexPath.row == 2) {
                //Eier
            } else if (indexPath.row == 3) {
                //Status
            }
        } else if (selectedRow == 1) {
            if (indexPath.row == 0) {
                //Endre epost
            } else if (indexPath.row == 1) {
                //Endre passord
            }
        } else if (selectedRow == 2) {
            if (indexPath.row == 0) {
                //Flip knapper
            }
        } else if (selectedRow == 3) {
            if (indexPath.row == 0) {
                //Brukeravtale
            } else if (indexPath.row == 1) {
                //Sammarbeidspartnere
            } else if (indexPath.row == 2) {
                //Kontakt oss
            } else if (indexPath.row == 3) {
                //Rapporter feil/bug
            }
        }
    }
    
    
    
    
    

    

    

    

}
