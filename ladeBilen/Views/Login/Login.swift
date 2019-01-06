//
//  loginViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import Disk
import AudioToolbox

class Login: UIViewController, UITextFieldDelegate {
    
    var app: App?
    
    var whitePanelLeadingOffset: CGFloat?
    var whitePanelTrailingOffset: CGFloat?
    var bannerStackTopOffset: CGFloat?
    var gestureWhitePanel: CGFloat?
    var gestureBanner: CGFloat?
    var isViewActive: Bool? = false
    var uid: String?
    var email: String? = ""
    var username: String? = ""
    var password: String? = ""
    var retypePeassword: String? = ""
    var loginViewIsPresented: Bool = true
    
    
    @IBOutlet var bannerStack: UIStackView!
        @IBOutlet var logo: UILabel!
        @IBOutlet var bannerStackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var whitePanelStack: UIStackView!
        @IBOutlet var whitePanel: UIView!
        @IBOutlet var whitePanelStackLeadingConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackTopConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var loginInputStack: UIStackView!
        @IBOutlet var loginInputStackLeadingConstraint: NSLayoutConstraint!
        @IBOutlet var loginInputStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var loginInputStackTopConstraint: NSLayoutConstraint!
        @IBOutlet var inputOneTextField: UITextField!
        @IBOutlet var inputTwoTextField: UITextField!
        @IBOutlet var inputThreeTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
        @IBOutlet var switchViewButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if app == nil {
            print("App er nil")
        } else {
            print("App er ikke nil")
        }
        inputOneTextField.delegate = self
        inputTwoTextField.delegate = self
        initialLoginView()
        addObservers()
    }
    
    override func viewDidLayoutSubviews() {
        initializeApperance()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    func initializeApperance() {
        whitePanel.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
        inputOneTextField.setBottomBorderGray()
        inputTwoTextField.setBottomBorderGray()
        inputThreeTextField.setBottomBorderGray()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? Register{
            nextViewController.uid = Auth.auth().currentUser?.uid
            nextViewController.email = self.inputOneTextField.text
            nextViewController.app = app
        } else if let nextViewController = segue.destination as? NavigationHome {
            let home = nextViewController.viewControllers.first as! Home
            home.app = app
        } else if let nextViewController = segue.destination as? ResetPassword {
            nextViewController.app = app
        }
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        if inputOneTextField.text!.isEmpty || inputTwoTextField.text!.isEmpty {
            if(inputOneTextField.text!.isEmpty){
                inputOneTextField.setBottomBorderRed()
            } else {
                inputTwoTextField.setBottomBorderRed()
            }
            AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
            
        } else if(loginViewIsPresented){
            Auth.auth().signIn(withEmail: inputOneTextField.text!, password: inputTwoTextField.text!, completion: { (user, error) in
                if (error != nil) {
                    self.inputOneTextField.setBottomBorderRed()
                    self.inputTwoTextField.setBottomBorderRed()
                    AudioServicesPlaySystemSound(Constants.VIBRATION_ERROR)
                } else {
                    self.app?.verifyStationCache(){
                        self.navigateUser()
                    }
                }
            })
        } else {
            if(inputTwoTextField.text == inputThreeTextField.text){
                Auth.auth().createUser(withEmail: inputOneTextField.text!, password: inputTwoTextField.text!) { (user, error) in
                    if (error != nil){
                        self.inputOneTextField.setBottomBorderRed()
                        AudioServicesPlaySystemSound(Constants.VIBRATION_WEAK)
                    } else {
                        self.performSegue(withIdentifier: "toRegister", sender: self)
                    }
                }
            } else {
                inputTwoTextField.setBottomBorderRed()
                inputThreeTextField.setBottomBorderRed()
                AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
            }
        }
    }
    
    func navigateUser(){
        print("Logging in")
        app?.verifyUserCache(){code in
            if code == 0 {
                self.app!.initializeApplication(done: {_ in
                    self.performSegue(withIdentifier: "toHome", sender: self)
                })
            } else {
                self.performSegue(withIdentifier: "toRegister", sender: self)
            }
        }
    }
 
    
    @IBAction func switchButtonClicked(_ sender: UIButton) {
        if(isViewActive == true){
            if loginViewIsPresented {
                print("Glemt passord")
                self.performSegue(withIdentifier: "toResetPassword", sender: self)
            } else {
                print("Allerede bruker")
                loginViewIsPresented = true
                print("Logge inn")
                loginButton.setTitle("Logg inn", for: .normal)
                switchViewButton.setTitle("Glemt passord?", for: .normal)
                inputOneTextField.placeholder = "E-Post"
                inputTwoTextField.placeholder = "Passord"
                inputThreeTextField.isHidden = true
            }
            
        } else {
            if(loginViewIsPresented){
                loginViewIsPresented = false
                print("Opprett bruker")
                loginButton.setTitle("Register", for: .normal)
                switchViewButton.setTitle("Allerede bruker?", for: .normal)
                inputOneTextField.placeholder = "E-Post"
                inputTwoTextField.placeholder = "Passord"
                inputThreeTextField.isHidden = false
            } else {
                loginViewIsPresented = true
                print("Logge inn")
                loginButton.setTitle("Logg inn", for: .normal)
                switchViewButton.setTitle("Opprette bruker?", for: .normal)
                inputOneTextField.placeholder = "E-Post"
                inputTwoTextField.placeholder = "Passord"
                inputThreeTextField.isHidden = true

            }
        }
    }

    
    func initialLoginView() {
        if(loginViewIsPresented){
            loginButton.setTitle("Logg inn", for: .normal)
            switchViewButton.setTitle("Opprette bruker?", for: .normal)
            inputOneTextField.placeholder = "E-Post"
            inputTwoTextField.placeholder = "Passord"
            inputThreeTextField.isHidden = true

        } else {
            loginButton.setTitle("Register", for: .normal)
            switchViewButton.setTitle("Allerede bruker?", for: .normal)
            inputOneTextField.placeholder = "E-Post"
            inputTwoTextField.placeholder = "Passord"
            inputThreeTextField.isHidden = false

        }
        
        isViewActive = false
        bannerStackTopConstraint.isActive = true
        bannerStackTopConstraint.constant = 40
        bannerStackTopOffset = bannerStackTopConstraint.constant
        
        whitePanelStackTopConstraint.constant = UIScreen.main.bounds.height * 0.45
        whitePanelStackLeadingConstraint.constant = 16
        whitePanelStackTrailingConstraint.constant = 16
        whitePanelStackBottomConstraint.constant = -17
        whitePanelLeadingOffset = whitePanelStackLeadingConstraint.constant
        whitePanelTrailingOffset = whitePanelStackTrailingConstraint.constant
        
        loginInputStackLeadingConstraint.constant = 36
        loginInputStackTrailingConstraint.constant = 36
        loginInputStackTopConstraint.constant = UIScreen.main.bounds.height * 0.50
    }

    
    @objc func keyboardWillShow() {
        print("Keyboard will show")
        activateLoginView()
    }
    
    func activateLoginView() {
        if(loginViewIsPresented){
            switchViewButton.setTitle("Glemt passord?", for: .normal)
        } else {
            switchViewButton.setTitle("Allerede bruker?", for: .normal)
        }
        
        isViewActive = true
        bannerStackTopConstraint.constant = 20
        
        whitePanelStackTopConstraint.constant = 0
        whitePanelStackLeadingConstraint.constant = 0
        whitePanelStackTrailingConstraint.constant = 0
        
        loginInputStackTopConstraint.constant = 120
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func keyboardWillHide() {
        print("Keybord will hide")
    }

    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let gesture = sender.translation(in: view)
        self.view.endEditing(true)
        gestureWhitePanel = gesture.y/whitePanelLeadingOffset!
        gestureBanner = (gesture.y/bannerStackTopOffset!)*4
        
        if(isViewActive == false){
            whitePanelStackTopConstraint.constant = gesture.y + UIScreen.main.bounds.height * 0.50
        } else {
            whitePanelStackTopConstraint.constant = gesture.y
        }
        
        if(whitePanelStackTopConstraint.constant < UIScreen.main.bounds.height * 0.50){
            whitePanelStackLeadingConstraint.constant = whitePanelStackTopConstraint.constant/whitePanelLeadingOffset!
            whitePanelStackTrailingConstraint.constant = whitePanelStackTopConstraint.constant/whitePanelTrailingOffset!
        }
        
        if (gestureBanner! < 40 && whitePanelStackTopConstraint.constant < UIScreen.main.bounds.height * 0.50) {
            bannerStackTopConstraint.constant = (whitePanelStackTopConstraint.constant/bannerStackTopOffset!)*4
            bannerStackTopConstraint.constant += 10
        }
                
        if (whitePanelStackTopConstraint.constant > 100) {
            loginInputStackTopConstraint.constant = whitePanelStackTopConstraint.constant
            loginInputStackTopConstraint.constant += 20
        }
        
        if sender.state == UIGestureRecognizer.State.ended {
            print("Ended movement")
            
            if (whitePanelStackTopConstraint.constant < self.view.bounds.height/2) {
                print("Return to active stance")
                self.initialLoginView()
                self.activateLoginView()
                
            } else if (whitePanelStackTopConstraint.constant >= self.view.bounds.height/2){
                print("Change to initial stance")
                self.initialLoginView()
                UIView.animate(withDuration: 0.5, animations: { 
                    self.view.layoutIfNeeded()
                })
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        
    }
    
}
