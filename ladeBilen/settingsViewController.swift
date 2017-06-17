//
//  settingsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 11.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import FirebaseAuth

class settingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

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
    
    
    

}
