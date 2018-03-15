//
//  ChangePassword.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox



class ChangeAuthInfo: UIViewController {
    
    var app: App?
    var rowIndex: Int?

    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var thirdTextField: UITextField!
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var whitePanelCorner: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.setBottomBorder()
        secondTextField.setBottomBorder()
        thirdTextField.setBottomBorder()
        changeButton.layer.cornerRadius = 20
        whitePanel.layer.cornerRadius = 20
        
        if rowIndex == 2 {
            firstTextField.placeholder = "Ny email"
            firstTextField.isSecureTextEntry = false
            firstTextField.keyboardType = .emailAddress
            secondTextField.placeholder = "Gjenta ny email"
            secondTextField.isSecureTextEntry = false
            secondTextField.keyboardType = .emailAddress
            thirdTextField.placeholder = "Passord"
            infoLabel.text = " "
        } else {
            firstTextField.placeholder = "Nytt passord"
            firstTextField.isSecureTextEntry = true
            firstTextField.keyboardType = .default
            secondTextField.placeholder = "Gjenta nytt passord"
            secondTextField.isSecureTextEntry = true
            secondTextField.keyboardType = .default
            thirdTextField.placeholder = "Gammelt passord"
            infoLabel.text = " "
        }
    }

    

    
    @IBAction func changeButton(_ sender: UIButton) {
        if firstTextField.text!.isEmpty || secondTextField.text!.isEmpty || thirdTextField.text!.isEmpty {
            if firstTextField.text!.isEmpty {
                firstTextField.setBottomBorderRed()
            }
            if secondTextField.text!.isEmpty {
                secondTextField.setBottomBorderRed()
            }
            if thirdTextField.text!.isEmpty {
                thirdTextField.setBottomBorderRed()
            }
            AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
            return
        }
        
        if rowIndex == 2 {
            if firstTextField.text != secondTextField.text {
                firstTextField.setBottomBorderRed()
                secondTextField.setBottomBorderRed()
                infoLabel.text = "Epostene er ulike"
                AudioServicesPlaySystemSound(Constants.VIBRATION_WEAK)
                return
            }
            
            let user = Auth.auth().currentUser
            //let credentialTest = credential(withEmail: , password: )
            let credential = EmailAuthProvider.credential(withEmail: app!.user!.email!, password: thirdTextField.text!)
            
            user?.reauthenticate(with: credential) { error in
                if error != nil {
                    self.thirdTextField.setBottomBorderRed()
                    self.infoLabel.text = "Passord er feil"
                    AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
                } else {
                    Auth.auth().currentUser?.updateEmail(to: self.firstTextField.text!) { (error) in
                        if error != nil {
                            self.firstTextField.setBottomBorderRed()
                            self.secondTextField.setBottomBorderRed()
                            self.infoLabel.text = "Epost er tatt"
                            AudioServicesPlaySystemSound(Constants.VIBRATION_ERROR)
                        } else {
                            self.app!.user!.email = self.firstTextField.text!
                            self.app!.setUserInDatabase(user: self.app!.user!)
                            self.infoLabel.text = "Epost oppdatert"
                        }
                    }
                }
            }
        } else {
            if firstTextField.text != secondTextField.text {
                firstTextField.setBottomBorderRed()
                secondTextField.setBottomBorderRed()
                infoLabel.text = "Pasordene er ulike"
                AudioServicesPlaySystemSound(Constants.VIBRATION_WEAK)
                return
            }
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: app!.user!.email!, password: thirdTextField.text!)
            
            user?.reauthenticate(with: credential) { error in
                if error != nil {
                    self.thirdTextField.setBottomBorderRed()
                    self.infoLabel.text = "Passord er feil"
                    AudioServicesPlaySystemSound(Constants.VIBRATION_ERROR)
                } else {
                    Auth.auth().currentUser?.updatePassword(to: self.firstTextField.text!) { (error) in
                        if error != nil {
                            self.firstTextField.setBottomBorderRed()
                            self.secondTextField.setBottomBorderRed()
                            self.infoLabel.text = "Passord kunne ikke bli oppdatert"
                            AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
                        } else {
                            self.infoLabel.text = "Passord oppdatert"
                        }
                    }
                }
            }
        }
    }
}
