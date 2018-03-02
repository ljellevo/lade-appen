//
//  Settings.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 30.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import Disk
import AudioToolbox

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    var user: User = GlobalResources.user!
    var userInfo: [String] = []
    var rowIndex: Int?

    let items = [
        ["Fornavn", "Etternavn", "E-post", "Endre Passord"],
        ["Endre Kontakt", "Innstillinger"],
        ["Om oss", "Rapporter feil"],
        ["Slett lagret data", "Log ut"]
    ]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: "EntryCell")
        tableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "DefaultCell")
        userInfo.append(GlobalResources.user?.nsDictionary["firstname"] as! String)
        userInfo.append(GlobalResources.user?.nsDictionary["lastname"] as! String)
        userInfo.append(GlobalResources.user?.nsDictionary["email"] as! String)
        print(GlobalResources.user?.connector)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        userInfo = []
        userInfo.append(GlobalResources.user?.nsDictionary["firstname"] as! String)
        userInfo.append(GlobalResources.user?.nsDictionary["lastname"] as! String)
        userInfo.append(GlobalResources.user?.nsDictionary["email"] as! String)
        tableView.reloadData()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (items[indexPath.section].count - 1) && indexPath.section == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CellId")
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.textLabel?.text = items[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = userInfo[indexPath.row]
            return cell
        } else if indexPath.section == 3 {
            let cell: DefaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultCell
            cell.label.text = items[indexPath.section][indexPath.row]
            return cell
        } else {
            let cell: DefaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultCell
            cell.label.text = items[indexPath.section][indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? ChangeUserInfo{
            nextViewController.rowIndex = rowIndex!
        }
        if let nextViewController = segue.destination as? ChangeAuthInfo {
            nextViewController.rowIndex = rowIndex!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        switch (indexPath.section, indexPath.row){
            case (0,0):
                rowIndex = indexPath.row
                performSegue(withIdentifier: "toChangeUserInfo", sender: self)
            case (0,1):
                rowIndex = indexPath.row
                performSegue(withIdentifier: "toChangeUserInfo", sender: self)
            case (0,2):
                rowIndex = indexPath.row
                performSegue(withIdentifier: "toChangeAuthInfo", sender: self)
            case (0,3):
                rowIndex = indexPath.row
                performSegue(withIdentifier: "toChangeAuthInfo", sender: self)
            case (1,0):
                performSegue(withIdentifier: "toChangeContact", sender: self)
            case (1,1):
                performSegue(withIdentifier: "toChangePreferences", sender: self)
            case (2,0):
                performSegue(withIdentifier: "toAbout", sender: self)
            case (2,1):
                performSegue(withIdentifier: "toReportBug", sender: self)
            case (3,0):
                deleteCache()
            case (3,1):
                logOut()
            default: break
        }
    }
    
    func deleteCache(){
        let alert = UIAlertController(title: "Sletting av lagrede data", message: "Sikker på at du vil slette den lagrede dataen? Dette vil ikke logge deg ut.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.default, handler: { action in
            AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
            do {
                try Disk.remove((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches)
                try Disk.remove("stations.json", from: .caches)
                try Disk.remove("favorites.json", from: .caches)
                print("Removed cache")
            } catch {
                print("Could not remove cache")
            }
        }))
        alert.addAction(UIAlertAction(title: "Nei", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func logOut(){
        let alert = UIAlertController(title: "Logge ut", message: "Sikker på at du vil logge ut?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.default, handler: { action in
            do{
                try FIRAuth.auth()?.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                self.present(controller, animated: false, completion: { () -> Void in
                })
            } catch {
                print ("Error")
            }
        }))
        alert.addAction(UIAlertAction(title: "Nei", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}
