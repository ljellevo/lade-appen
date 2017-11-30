//
//  Settings.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 30.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class Settings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let options = ["Søke instillinger", "Bruker", "Utsene", "Om oss", "Logg ut"]


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = self.options[indexPath.row]
        return cell
    }
    
    

}
