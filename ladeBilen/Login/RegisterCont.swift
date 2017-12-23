//
//  RegisterCont.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class RegisterCont: UIViewController {
    var email: String?
    var firstname: String?
    var lastname: String?
    var notificationDuration: Int?

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
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whitePannel.layer.cornerRadius = 20
        nextButton.layer.cornerRadius = 20

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registerFinished = segue.destination as? RegisterFinished{
            registerFinished.email = email
            registerFinished.firstname = firstname
            registerFinished.lastname = lastname
            registerFinished.fastcharge = fastchargeSwitch.isOn
            registerFinished.parkingfee = parkingFeeSwitch.isOn
            registerFinished.cloudStorage = cloudStorageSwitch.isOn
            registerFinished.notifications = notificationSwitch.isOn
            registerFinished.notificationsDuration = notificationDuration
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegisterFinish", sender: self)
    }
}
