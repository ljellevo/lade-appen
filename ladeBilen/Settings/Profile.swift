//
//  Settings.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 30.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let items = [
        ["Navn", "E-post", "Passord", "Bilmodell"],
        ["Kontakter", "Parkerings Avgift", "Hastighet"],
        ["Cloud lagring", "Om oss", "Rapporter feil", "Log ut"]
    ]
    
    let section = ["Bruker", "Søke innstillinger", "Innstillinger"]


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 40
        confifureHeaderFrame()
    }
    
    func confifureHeaderFrame(){
        let headerView = tableView.tableHeaderView
        var frame = headerView?.frame
        frame?.size.height = 140
        headerView?.frame = frame!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        view.tintColor = UIColor.white
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        return cell
    }
}
