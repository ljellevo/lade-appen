//
//  editSettingsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 18.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class EditSettings: UIViewController {
    
    var selectedRow: Int = 100
    
    @IBOutlet weak var chargingStationStack: UIStackView!
        @IBOutlet weak var fastChargeSwitch: UISwitch!
        @IBOutlet weak var publicSwitch: UISwitch!
        @IBOutlet weak var freeSwitch: UISwitch!
        @IBOutlet weak var alwaysOpenSwitch: UISwitch!
        @IBOutlet weak var unlimitedParkingSwitch: UISwitch!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
