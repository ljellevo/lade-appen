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
    
    var app: App!
    
    let cacheManagement = CacheManagement()
    var window: UIWindow?
    var user: User?
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
        user = app.user
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: "EntryCell")
        tableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "DefaultCell")
        userInfo.append(user?.nsDictionary["firstname"] as! String)
        userInfo.append(user?.nsDictionary["lastname"] as! String)
        userInfo.append(user?.nsDictionary["email"] as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        user = app.user
        userInfo = []
        userInfo.append(user?.nsDictionary["firstname"] as! String)
        userInfo.append(user?.nsDictionary["lastname"] as! String)
        userInfo.append(user?.nsDictionary["email"] as! String)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if let view = self.navigationController?.viewControllers[0] as? Home {
                view.addAnnotationsToMap()
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
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
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CellId")
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
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
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? ChangeUserInfo{
            nextViewController.app = app
            nextViewController.rowIndex = rowIndex!
        }
        if let nextViewController = segue.destination as? ChangeAuthInfo {
            nextViewController.app = app
            nextViewController.rowIndex = rowIndex!
        }
        if let nextViewController = segue.destination as? ChangeContact {
            nextViewController.app = app
        }
        if let nextViewController = segue.destination as? ChangePreferences {
            nextViewController.app = app
        }
        if let nextViewController = segue.destination as? ReportBug {
            nextViewController.app = app
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        let alert = UIAlertController(title: "Sletting av lagrede data", message: "Sikker på at du vil slette den lagrede dataen? Dette vil ikke logge deg ut.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: { action in
            AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
            _ = self.app.removeAllCache()
        }))
        alert.addAction(UIAlertAction(title: "Nei", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func logOut(){
        let alert = UIAlertController(title: "Logge ut", message: "Sikker på at du vil logge ut?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: { action in
            do{
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                controller.app = App()
                self.present(controller, animated: false, completion: { () -> Void in
                })
            } catch {
                print ("Error")
            }
        }))
        alert.addAction(UIAlertAction(title: "Nei", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}
