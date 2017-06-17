//
//  welcomeViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 16.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class welcomeViewController: UIViewController, UITextFieldDelegate {
    
    var firstname: String = ""
    var email: String = ""
    var password: String = ""
    var retypePassword: String = ""

    
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
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "toHome", sender: self)
                print("User is logged in")
            } else {
                print("User is not logged in")
            }
        }
        //checkIfUserIsLoggedIn()
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
    
    func checkIfUserIsLoggedIn(){
        if (FIRAuth.auth()?.currentUser?.uid != nil){
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
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
            registrationInputOne.isSecureTextEntry = false
            registrationInputTwo.isSecureTextEntry = false
            registrationInputOne.autocapitalizationType = .words
            registerButton.setTitle("Neste", for: .normal)
            // Bytt til fornavn/etternavn og sett inn informasjonen
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (emailTextField.isFirstResponder) {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if (passwordTextField.isFirstResponder){
            passwordTextField.resignFirstResponder()
            //Logg inn metode kalles her
            loginUserFunc()
            print("login")
        } else if (registrationInputOne.isFirstResponder) {
            registrationInputOne.resignFirstResponder()
            registrationInputTwo.becomeFirstResponder()
        } else if (registrationInputTwo.isFirstResponder && registrationCounter < 1) {
            registerButtonFunc()
            registrationInputOne.becomeFirstResponder()
            registrationInputTwo.resignFirstResponder()
            
        } else if (registrationInputTwo.isFirstResponder && registrationCounter == 1) {
            registrationInputTwo.resignFirstResponder()
            //Registrer og logg inn
            print("Registrer")
        }
        return false
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        loginUserFunc()
    }
    
    func loginUserFunc(){
        if (emailTextField.text != "" && passwordTextField.text != "" ){
            email = emailTextField.text!
            password = passwordTextField.text!
            loginUser()
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        registerButtonFunc()
    }
    
    func registerButtonFunc(){
        if (registrationCounter == 0) {
            if (registrationInputOne.text != "" && registrationInputTwo.text != ""){
                firstname = registrationInputOne.text!
                email = registrationInputTwo.text!
                registrationCounter += 1
                registrationInputOne.text = ""
                registrationInputTwo.text = ""
                registrationInputOne.isSecureTextEntry = true
                registrationInputTwo.isSecureTextEntry = true
                registrationInputOne.autocapitalizationType = .none
                registrationInputOne.becomeFirstResponder()
                registrationInputTwo.resignFirstResponder()
                
                registrationInputOne.placeholder = "Passord"
                registrationInputTwo.placeholder = "Bekreft passord"
                registerButton.setTitle("Registrer", for: .normal)
            }
            
            //Bytt til passord/retype passord
        } else if (registrationCounter == 1) {
            
            if (registrationInputOne.text != "" && registrationInputTwo.text != ""){
                password = registrationInputOne.text!
                retypePassword = registrationInputTwo.text!
                if (password == retypePassword){
                    //Prøv å registre og logg inn
                    registerUserInDatabase()
                }
            }
        }
    }
    
    func registerUserInDatabase(){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                //Feil under registrering av bruker
                print("Error creating user")
            } else {
                //Suksess
                print("Success creating user")
                self.registerUserInfoInDatabase()
                //self.loginUser()
            }
        })
    }
    
    func registerUserInfoInDatabase(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        let values = ["First name" : firstname, "Email" : email]
        
        ref.child("User_Info").child(uid as String!).updateChildValues(values) { (error, ref) in
            if (error != nil){
                print("Error saving info in database")
            } else {
                print("Registration successfull")
                self.loginUser()
            }
        }
    }
    
    func loginUser(){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if (error != nil) {
                //Feil under innloggig
                print("Error when signing in")
            } else {
                //Suksess
                print("User signed in successfully")
                self.performSegue(withIdentifier: "toHome", sender: self)

            }
        })
    }
    
    
    
}
