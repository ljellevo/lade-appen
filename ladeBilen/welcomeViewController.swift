//
//  welcomeViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 16.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextFieldStack: UIStackView!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonStack: UIStackView!
        @IBOutlet weak var loginButton: UIStackView!
        @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var registrationTextFieldStack: UIStackView!
        @IBOutlet weak var registrationInputOne: UITextField!
        @IBOutlet weak var registrationInputTwo: UITextField!
    
    @IBOutlet weak var registrationButtonStack: UIStackView!
        @IBOutlet weak var registerButton: UIButton!
        @IBOutlet weak var allreadyUserButton: UIButton!
    
    @IBOutlet weak var bannerStack: UIStackView!
        @IBOutlet weak var bannerStackTopConstraint: NSLayoutConstraint!
        @IBOutlet weak var bannerStackCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginInitialButton: UIButton!
    @IBOutlet weak var registerInitalButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        addObservers()
        initialConfig()
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
    }
    
    func initialConfig(){
        bannerStackTopConstraint.isActive = false
        loginTextFieldStack.isHidden = true
        loginButtonStack.isHidden = true
        registrationTextFieldStack.isHidden = true
        registrationButtonStack.isHidden = true
    }
    
    func hideInitialView(){
        loginInitialButton.isHidden = true
        registerInitalButton.isHidden = true
        bannerStackTopConstraint.isActive = true
        bannerStackCenterConstraint.isActive = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func loadLoginConfig(){
        self.loginTextFieldStack.isHidden = false
        self.loginButtonStack.isHidden = false
        self.loginTextFieldStack.alpha = 0.0
        self.loginButtonStack.alpha = 0.0

        hideInitialView()

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) ) {
            UIView.animate(withDuration: 0.5) {
                self.loginTextFieldStack.alpha = 1.0
                self.loginButtonStack.alpha = 1.0
            }
        }
    }
    
    func loadRegistrationConfig(){
        self.registrationTextFieldStack.isHidden = false
        self.registrationButtonStack.isHidden = false
        self.registrationTextFieldStack.alpha = 0.0
        self.registrationButtonStack.alpha = 0.0
    
        
        hideInitialView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) ) {
            UIView.animate(withDuration: 0.5) {
                self.registrationTextFieldStack.alpha = 1.0
                self.registrationButtonStack.alpha = 1.0
            }
        }
    }

    func keyboardWillShow(notification: NSNotification){
        print("Keyboard will show")
    }
    
    func keyboardWillHide(){
        print("Keyboard will hide")
        
    }
    
    @IBAction func loginInitalButton(_ sender: UIButton) {
        loadLoginConfig()
    }
    
    @IBAction func registerInitalButton(_ sender: UIButton) {
        registerButton.setTitle("Neste", for: .normal)
        loadRegistrationConfig()
        
    }
    
    
}
