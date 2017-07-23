//
//  stationsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.07.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class connectorCells: UITableViewCell {
    @IBOutlet weak var connectorTypeLabel: UILabel!
    @IBOutlet weak var compatibleLabel: UILabel!
    @IBOutlet weak var icon: UIView!
}

class statusCells: UITableViewCell {
    @IBOutlet weak var typeContactLabel: UILabel!
    @IBOutlet weak var statusContactLabel: UILabel!
    @IBOutlet weak var contactIcon: UIImageView!

}

class sectionCells: UITableViewCell {
    @IBOutlet weak var infoSectionLabel: UILabel!
}

class stationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var connectorTableView: UITableView!
    @IBOutlet weak var descriptionTableView: UITableView!
    
    @IBOutlet var statusView: UIView!
    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var viewSwitchControl: UISegmentedControl!
    
    
    let connectorTypes: [String] = ["Hurtig", "Hurtig", "Standard", "Standard"]
    let compatible: [String] = ["Ledig", "Optatt", "Ledig", "Ledig"]
    let connectorIcon: [UIImage] = [#imageLiteral(resourceName: "CCS.png"), #imageLiteral(resourceName: "CHAdeMO.png"), #imageLiteral(resourceName: "Schuko_CEE_7_4.png"), #imageLiteral(resourceName: "Schuko_CEE_7_4.png")]
    let section: [String] = ["Info"]
    
    
    
    let cellReuseIdentifierConnector = "connectorCell"
    let cellReuseIdentifierInfo = "infoCell"
    let cellReuseIdentifierDescription = "descCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTableView.tableFooterView = UIView()
        
        connectorTableView.delegate = self
        connectorTableView.dataSource = self
        
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if (tableView == self.connectorTableView){
            count = self.connectorTypes.count
        }
        
        if (tableView == self.descriptionTableView){
            count = self.connectorTypes.count + self.section.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellReturn: UITableViewCell?
        if (tableView == self.connectorTableView){
            var cell: connectorCells
            cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierConnector, for: indexPath) as! connectorCells
            cell.connectorTypeLabel?.text = connectorTypes[indexPath.row]
            cell.compatibleLabel?.text = compatible[indexPath.row]
        
            if (indexPath.row == 1) {
                cell.icon?.backgroundColor = UIColor(red: 255.0/255, green: 143.0/255, blue: 121.0/255, alpha: 1.0)
            } else {
                cell.icon?.backgroundColor = UIColor(red: 122.0/255, green: 205.0/255, blue: 60.0/255, alpha: 1.0)
            }
            cell.icon.layer.cornerRadius = 10
            cellReturn = cell as UITableViewCell

        }
        
        if (tableView == self.descriptionTableView){
            if (indexPath.row < (connectorTypes.count)){
                var cell: statusCells
                cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierInfo, for: indexPath) as! statusCells
                cell.typeContactLabel?.text = connectorTypes[indexPath.row]
                cell.statusContactLabel?.text = compatible[indexPath.row]
                cell.contactIcon.image = connectorIcon[indexPath.row]
                cellReturn = cell as UITableViewCell
            } else if (indexPath.row >= (connectorTypes.count)){
                var cell: sectionCells
                cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierDescription, for: indexPath) as! sectionCells
                cell.infoSectionLabel?.text = section[indexPath.row - connectorTypes.count]
                cellReturn = cell as UITableViewCell
            }
        }
        return cellReturn!
    }
    
    
    
    @IBAction func viewSwitchControl(_ sender: UISegmentedControl) {
        switch viewSwitchControl.selectedSegmentIndex {
        case 0:
            statusView.isHidden = false
            infoView.isHidden = true
        case 1:
            statusView.isHidden = true
            infoView.isHidden = false
        default:
            break;
        }
    }
}
