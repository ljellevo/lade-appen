//
//  settingsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 11.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsOld: UITableViewController {
    
    let options = ["Søke instillinger", "Bruker", "Utsene", "Om oss", "Logg ut"]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCellOld", for: indexPath)
        cell.textLabel?.text = self.options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < 4) {
            print(indexPath.row)
            segue()
        } else if (indexPath.row == 4) {
            print(indexPath.row)
            logoutUser()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedSettings" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let destination = segue.destination as! DetailedSettings
                //destination.selectedRow = indexPath.row
            }
        }
    }
    
    func segue(){
        self.performSegue(withIdentifier: "toDetailedSettings", sender: self)
    }
    
    func logoutUser(){
        do {
            try FIRAuth.auth()?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
            self.present(controller, animated: false, completion: { () -> Void in
            })
        } catch let signOutError as NSError {
            print ("Error signing out: ", signOutError)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    func flipButtonStack(){
        if (defaults.integer(forKey: "flip") == 0 || defaults.integer(forKey: "flip") == 1){
            //Flytter buttonsStack til venstre
            defaults.set(2, forKey: "flip")
        } else {
            //Flytter buttonsStack til høyre
            defaults.set(1, forKey: "flip")
        }
        
    }
    @IBAction func flipButtonsStackButton(_ sender: UIButton) {
        flipButtonStack()
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // vc is the Storyboard ID that you added
            // as! ... Add your ViewController class name that you want to navigate to
            let controller = storyboard.instantiateViewController(withIdentifier: "Welcome") as! welcomeViewController
            self.present(controller, animated: false, completion: { () -> Void in
            })
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
 */
    
    
    
    

}
