//
//  stationsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.07.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class stationsCells: UITableViewCell {
    @IBOutlet weak var connectorTypeLabel: UILabel!
    @IBOutlet weak var compatibleLabel: UILabel!
    @IBOutlet weak var icon: UIView!
}

class stationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let connectorTypes: [String] = ["Hurtig", "Hurtig", "Standard", "Standard"]
    let compatible: [String] = ["Kompatibel", "Ikke kompatibel", "Kompatibel", "Kompatibel"]
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.connectorTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:stationsCells  = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! stationsCells
        cell.connectorTypeLabel?.text = connectorTypes[indexPath.row]
        cell.compatibleLabel?.text = compatible[indexPath.row]
        
        if (indexPath.row == 1) {
            cell.icon?.backgroundColor = UIColor(red: 255.0/255, green: 143.0/255, blue: 121.0/255, alpha: 1.0)
        } else {
            cell.icon?.backgroundColor = UIColor(red: 122.0/255, green: 205.0/255, blue: 60.0/255, alpha: 1.0)
        }
        cell.icon.layer.cornerRadius = 10
 
        return cell
    }
}
