//
//  Settings.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 30.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?

    let items = [
        ["Navn", "E-post", "Passord", "Bilmodell"],
        ["Kontakter", "Parkerings Avgift", "Hastighet"],
        ["Cloud lagring", "Om oss", "Rapporter feil", "Log ut"]
    ]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        //confifureHeaderFrame()
    }
    
    func confifureHeaderFrame() {
        let headerView = tableView.tableHeaderView
        var frame = headerView?.frame
        frame?.size.height = Constants.SCREEN_HEIGHT/4
        headerView?.layer.masksToBounds = true
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: ceil(Constants.SCREEN_HEIGHT/4))
        label.textAlignment = .center
        label.text = "Ludvig Johannes Nohre Ellevold"
        label.backgroundColor = UIColor.white
        label.layer.masksToBounds = true
        headerView?.addSubview(label)
        headerView?.frame = frame!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        if(indexPath.section == (items.count - 1) && indexPath.row == (items[indexPath.section].count - 1)){
            print("Logout")
            do{
                try FIRAuth.auth()?.signOut()
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
                self.window?.rootViewController=vc
                self.window?.makeKeyAndVisible()
            } catch {
                print ("Error")
            }
        }
    }
}
