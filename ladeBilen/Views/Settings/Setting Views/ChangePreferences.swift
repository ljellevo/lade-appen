//
//  ChangePrefrences.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ChangePreferences: UIViewController {
    var app: App!
    var notificationDuration: Int = 30
    
    @IBOutlet weak var whitePannel: UIView!
    
    @IBOutlet weak var fastChargeLabel: UILabel!
    @IBOutlet weak var fastchargeSwitch: UISwitch!
    
    @IBOutlet weak var parkingFeeLabel: UILabel!
    @IBOutlet weak var parkingFeeSwitch: UISwitch!
    
    @IBOutlet weak var reduceDataSwitch: UISwitch!
    
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
        fastchargeSwitch.isOn = app.user!.fastCharge
        parkingFeeSwitch.isOn = app.user!.parkingFee
        reduceDataSwitch.isOn = app.user!.reduceData
        notificationSwitch.isOn = app.user!.notifications
        durationSlider.value = Float(app.user!.notificationDuration)
        let value = app.user!.notificationDuration
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
        app.user?.fastCharge = fastchargeSwitch.isOn
        app.user?.parkingFee = parkingFeeSwitch.isOn
        app.user?.reduceData = reduceDataSwitch.isOn
        app.user?.notifications = notificationSwitch.isOn
        app.user?.notificationDuration = notificationDuration
        app.setUserInDatabase(user: app!.user!, done: { error in
            if error != nil {
                let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                banner.duration = 2
                banner.show()
            } else {
                self.app.findFilteredStations()
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                let banner = StatusBarNotificationBanner(title: "Instillinger er oppdatert", style: .success)
                banner.duration = 2
                banner.show()
            }
        })
        
    }
}
