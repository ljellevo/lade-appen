//
//  ChangePrefrences.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class ChangePreferences: UIViewController {
    
    var notificationDuration: Int = 30
    
    @IBOutlet weak var whitePannel: UIView!
    
    @IBOutlet weak var fastChargeLabel: UILabel!
    @IBOutlet weak var fastchargeSwitch: UISwitch!
    
    @IBOutlet weak var parkingFeeLabel: UILabel!
    @IBOutlet weak var parkingFeeSwitch: UISwitch!
    
    @IBOutlet weak var cloudStorageLabel: UILabel!
    
    @IBOutlet weak var cloudStorageSwitch: UISwitch!
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        whitePannel.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
    }

    
    @IBAction func sliderAction(_ sender: UISlider) {
        let value = Int(sender.value)
        notificationDuration = value
        if value < 60 {
            durationTimeLabel.text = String(value) + " min"
        } else if value == 60{
            durationTimeLabel.text = "1 time"
        } else if value < 120 {
            durationTimeLabel.text = String(value / 60) + " time, " + String(value % 60) + " min"
        } else if value == 120{
            durationTimeLabel.text = "2 timer"
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
    }
    



}
