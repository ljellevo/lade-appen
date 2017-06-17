//
//  welcomeViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 16.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController, UITextFieldDelegate {
    
    var firstname: String = ""
    var email: String = ""

    
    var registrationCounter = 0
    var registrationArray: [String] = []

    @IBOutlet weak var loginTextFieldStack: UIStackView!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonStack: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
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
    @IBOutlet weak var backButton: UIButton!

    
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
        loginInitialButton.layer.cornerRadius = 20
        registerInitalButton.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 20
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        registrationInputOne.setBottomBorder()
        registrationInputTwo.setBottomBorder()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        registrationInputOne.delegate = self
        registrationInputTwo.delegate = self
    }
    
    func initialConfig(){
        registrationCounter = 0
        bannerStackTopConstraint.isActive = false
        loginTextFieldStack.isHidden = true
        loginButtonStack.isHidden = true
        registrationTextFieldStack.isHidden = true
        registrationButtonStack.isHidden = true
        backButton.isHidden = true
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
    
    func loadBackButton(){
        self.backButton.isHidden = false
        self.backButton.alpha = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) ) {
            UIView.animate(withDuration: 0.5) {
                self.backButton.alpha = 1.0
            }
        }
    }
    
    func loadLoginConfig(){
        self.loginTextFieldStack.isHidden = false
        self.loginButtonStack.isHidden = false
        self.loginTextFieldStack.alpha = 0.0
        self.loginButtonStack.alpha = 0.0

        hideInitialView()
        loadBackButton()

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
        loadBackButton()
        
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
    @IBAction func backButton(_ sender: UIButton) {
        if (registrationCounter == 0) {
            self.view.endEditing(true)
            initialConfig()
            bannerStackTopConstraint.isActive = false
            bannerStackCenterConstraint.isActive = true
        
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) ) {
                UIView.animate(withDuration: 0.5) {
                    self.loginInitialButton.isHidden = false
                    self.registerInitalButton.isHidden = false
                }
            }
        } else if (registrationCounter == 1){

            registrationCounter -= 1
            registrationInputOne.placeholder = "Fornavn"
            registrationInputTwo.placeholder = "E-Post"
            registrationInputOne.text = firstname
            registrationInputTwo.text = email
            registerButton.setTitle("Neste", for: .normal)
            // Bytt til fornavn/etternavn og sett inn informasjonen
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (emailTextField.isFirstResponder) {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if (passwordTextField.isFirstResponder){
            //Logg inn metode kalles her
            print("login")
        } else if (registrationInputOne.isFirstResponder) {
            registrationInputOne.resignFirstResponder()
            registrationInputTwo.becomeFirstResponder()
        } else if (registrationInputTwo.isFirstResponder && registrationCounter < 1) {
            registrationInputTwo.resignFirstResponder()
            registrationInputOne.becomeFirstResponder()
        } else if (registrationInputTwo.isFirstResponder && registrationCounter == 1) {
            registrationInputTwo.resignFirstResponder()
            //Registrer og logg inn
            print("Registrer")
        }
        return false
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if (emailTextField.text != "" && passwordTextField.text != "" ){
            //Prøv å logg inn
        }
        
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        if (registrationCounter == 0) {
            if (registrationInputOne.text != "" && registrationInputTwo.text != ""){
                firstname = registrationInputOne.text!
                email = registrationInputTwo.text!
                registrationCounter += 1
                registrationInputOne.text = ""
                registrationInputTwo.text = ""
                
                registrationInputOne.placeholder = "Passord"
                registrationInputTwo.placeholder = "Bekreft passord"
                registerButton.setTitle("Registrer", for: .normal)
            }
            
            //Bytt til passord/retype passord
        } else if (registrationCounter == 1) {
            var password = ""
            var retypePassword = ""
            if (registrationInputOne.text != "" && registrationInputTwo.text != ""){
                password = registrationInputOne.text!
                retypePassword = registrationInputTwo.text!
                if (password == retypePassword){
                    print("Registrer bruker")
                    //Prøv å registre og logg inn
                    
                }
            }
            
            
        }
    }
    
    
    
}
