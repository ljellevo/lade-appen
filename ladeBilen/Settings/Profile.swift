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

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    var user: User = GlobalResources.user!
    var userInfoDictionary: NSDictionary?
    var userInfo: [String] = []

    let items = [
        ["Fornavn", "Etternavn", "E-post", "Passord"],
        ["Kontakt", "Parkerings Avgift", "Hastighet", "Notifikasjons Varighet"],
        ["Cloud lagring", "Om oss", "Rapporter feil", "Slett cache", "Log ut"]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row <= items[indexPath.section].count && indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (items[indexPath.section].count - 1) && indexPath.section == 0 {
            let cell: EntryCell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
            cell.label.text = items[indexPath.section][indexPath.row]
            if user != nil {
                cell.textField.text = userInfo[indexPath.row]
            }
            return cell
        } else {
            let cell: DefaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultCell
            cell.label.text = items[indexPath.section][indexPath.row]
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        if indexPath.row <= items[indexPath.section].count && indexPath.section == 0 {
            //Last opp tastatur
        }
        
        if indexPath.section == 2 && indexPath.row == 3 {
            do {
                try Disk.remove((FIRAuth.auth()?.currentUser?.uid)! + ".json", from: .caches)
                print("Removed cache")
            } catch {
                print("Could not remove cache")
            }
        }
        if(indexPath.section == (items.count - 1) && indexPath.row == (items[indexPath.section].count - 1)){
            print("Logout")
            do{
                try FIRAuth.auth()?.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                self.present(controller, animated: false, completion: { () -> Void in
                })
            } catch {
                print ("Error")
            }
        }
    }
}
