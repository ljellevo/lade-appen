//
//  ResetPassord.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 06/01/2019.
//  Copyright © 2019 Ludvig Ellevold. All rights reserved.
//

import UIKit
import FirebaseAuth
import NotificationBannerSwift

class ResetPassword: UIViewController {
    
    var app: App!

    @IBOutlet weak var whitePannel: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whitePannel.layer.cornerRadius = 20
        actionButton.layer.cornerRadius = 20
        self.emailTextField.setBottomBorder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetActionButton(_ sender: UIButton) {
        guard let text = emailTextField.text, !text.isEmpty else {
            emailTextField.setBottomBorderRed()
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error != nil {
                let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                banner.show()
            } else {
                self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
            }
        }
    }
    
    @IBAction func backActionButton(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToLogin", sender: nil)
    }
}
