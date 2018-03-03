//
//  Register.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class Register: UIViewController {
    
    var uid: String?
    var email: String?

    @IBOutlet weak var whitePannel: UIView!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var nextViewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whitePannel.layer.cornerRadius = 20
        nextViewButton.layer.cornerRadius = 20
        self.firstnameTextField.setBottomBorder()
        self.lastnameTextField.setBottomBorder()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow() {
        firstnameTextField.setBottomBorder()
        lastnameTextField.setBottomBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? RegisterCont{
            nextViewController.uid = FIRAuth.auth()?.currentUser?.uid
            nextViewController.email = FIRAuth.auth()?.currentUser?.email
            nextViewController.firstname = self.firstnameTextField.text
            nextViewController.lastname = self.lastnameTextField.text
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if self.firstnameTextField.text != "" && self.lastnameTextField.text != "" {
            self.performSegue(withIdentifier: "toRegisterCont", sender: self)
        } else {
            if self.firstnameTextField.text == "" {
                firstnameTextField.setBottomBorderRed()
            } else if self.lastnameTextField.text == "" {
                lastnameTextField.setBottomBorderRed()
            } else {
                firstnameTextField.setBottomBorderRed()
                lastnameTextField.setBottomBorderRed()
            }
            AudioServicesPlaySystemSound(Constants.VIBRATION_WEAK)
        }
    }
}
