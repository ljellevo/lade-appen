//
//  settingsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 11.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print(defaults.integer(forKey: "flip"))
        
    }
    
    

}
