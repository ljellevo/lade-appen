//
//  welcomeViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 16.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var loginOptionButton: UIButton!
    @IBOutlet weak var registrationOptionButton: UIButton!
    @IBOutlet weak var loginRegisterAccountButton: UIButton!

    
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBackgroundHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textfieldStackHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func addObservers(){
        print("Adding Observers")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObservers(){
        print("Removing Observers")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupButtons(){
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        retypePasswordTextField.setBottomBorder()
    }
    
    
    
    
    
    
    @IBAction func loginOptionButton(_ sender: UIButton) {
        loadLoginConfig()
    }
    
    
    @IBAction func registrationOptionButton(_ sender: UIButton) {
        loadRegistrationConfig()
    }
    
    func loadLoginConfig(){
        retypePasswordTextField.isHidden = true
        textfieldStackHeightConstraint.constant = 110
        
        
        self.view.layoutIfNeeded()
        removeCover()
    }
    
    func loadRegistrationConfig(){
        loginRegisterAccountButton.setTitle("Next", for: .normal)
        removeCover()
        
    }
    
    func removeCover(){
        loginOptionButton.isHidden = true
        registrationOptionButton.isHidden = true
        statusBackgroundHeightConstraint.constant = 40
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyboardWillShow(notification: NSNotification){
        //Flytter login button slik at den ligger ovenfor keyboard når keyboard blir aktivert
        print("Keyboard will show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.loginButtonBottomConstraint.constant += keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(){
        print("Keyboard will hide")
        
    }
    
    
    @IBAction func loginRegisterAccountButton(_ sender: UIButton) {
        
    }
    
}
