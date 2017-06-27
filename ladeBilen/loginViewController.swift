//
//  loginViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class loginViewController: UIViewController, UITextFieldDelegate {
    
    var whitePanelLeadingOffset: CGFloat?
    var whitePanelTrailingOffset: CGFloat?
    var bannerStackTopOffset: CGFloat?
    var gestureWhitePanel: CGFloat?
    var gestureBanner: CGFloat?
    var isLoginActive: Bool? = true
    var isViewActive: Bool? = false
    var hasRegistrationBegun: Bool? = false
    var email: String? = ""
    var firstname: String? = ""
    var password: String? = ""
    var retypePeassword: String? = ""
    
    
    @IBOutlet var bannerStack: UIStackView!
        @IBOutlet var logo: UILabel!
        @IBOutlet var bannerStackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var whitePanelStack: UIStackView!
        @IBOutlet var whitePanel: UIView!
        @IBOutlet var whitePanelStackHeightConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackLeadingConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackTopConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var loginInputStack: UIStackView!
        @IBOutlet var loginInputStackLeadingConstraint: NSLayoutConstraint!
        @IBOutlet var loginInputStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var loginInputStackTopConstraint: NSLayoutConstraint!
        @IBOutlet var loginInputStackBottomConstraint: NSLayoutConstraint!
        @IBOutlet var inputOneTextField: UITextField!
        @IBOutlet var inputTwoTextField: UITextField!

        @IBOutlet var loginButton: UIButton!
        @IBOutlet var switchViewButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        inputOneTextField.delegate = self
        inputTwoTextField.delegate = self
        initializeApperance()
        initialLoginView()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


    
    func initializeApperance() {
        whitePanel.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
        inputOneTextField.setBottomBorderGray()
        inputTwoTextField.setBottomBorderGray()
    }
    
    func initialLoginView() {
        initializeBannerStack()
        initializeWhitePanelStack()
        initializeLoginInputStack()
        isViewActive = false
    }
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        if (isLoginActive == true) {
            //Try to log in
        } else {
            if (hasRegistrationBegun == false){
                //Present next registration view

            } else {
                //try to registrate user
            }
            //Check registration stages
        }
    }
    
    @IBAction func switchButtonClicked(_ sender: UIButton) {
        if (isViewActive == true) {
            if (isLoginActive == true){
                //Forgot password
            }
            else {
                if (hasRegistrationBegun == false) {
                    //Already user
                } else {
                    //Navigate back
                }
            }
        } else {
            switchView()
        }
        
    }
    
    func switchView() {
        loginInputStackBottomConstraint.constant = -214
        whitePanelStackHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) ) {
            self.initializeBannerStack()
            self.initializeWhitePanelStack()
            self.initializeLoginInputStack()
            if (self.isLoginActive == true){
                self.handleInputFieldsDisplayText(status: 2)
            } else {
                self.handleInputFieldsDisplayText(status: 1)
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func handleInputFieldsDisplayText(status: Int){
        if (status == 1){
            inputOneTextField.text = email
            inputTwoTextField.text = ""
            inputOneTextField.placeholder = "E-Post"
            inputTwoTextField.placeholder = "Password"
            loginButton.setTitle("Logg inn", for: .normal)
            switchViewButton.setTitle("Opprette bruker?", for: .normal)
            self.isLoginActive = true
        } else if (status == 2) {
            inputOneTextField.text = firstname
            inputTwoTextField.text = email
            inputOneTextField.placeholder = "Fornavn"
            inputTwoTextField.placeholder = "E-Post"
            loginButton.setTitle("Neste", for: .normal)
            switchViewButton.setTitle("Allerede bruker?", for: .normal)
            self.isLoginActive = false
        } else if (status == 3) {
            inputOneTextField.text = ""
            inputTwoTextField.text = ""
            inputOneTextField.placeholder = "Passord"
            inputTwoTextField.placeholder = "Gjenta passord"
            loginButton.setTitle("Registrer", for: .normal)
            switchViewButton.setTitle("Tilbake", for: .normal)
            self.isLoginActive = false
        }
    }
    
    func initializeBannerStack() {
        bannerStackTopConstraint.isActive = true
        bannerStackTopConstraint.constant = 40
        bannerStackTopOffset = bannerStackTopConstraint.constant
    }
    
    func initializeWhitePanelStack() {
        whitePanelStackTopConstraint.isActive = false
        whitePanelStackHeightConstraint.isActive = true
        whitePanelStackHeightConstraint.constant = 287
        whitePanelStackLeadingConstraint.constant = 16
        whitePanelStackTrailingConstraint.constant = 16
        whitePanelStackTopConstraint.constant = 0
        whitePanelStackBottomConstraint.constant = -17
        whitePanelLeadingOffset = whitePanelStackLeadingConstraint.constant
        whitePanelTrailingOffset = whitePanelStackTrailingConstraint.constant
    }
    
    func initializeLoginInputStack() {
        loginInputStackBottomConstraint.isActive = true
        loginInputStackTopConstraint.isActive = false
        loginInputStackLeadingConstraint.constant = 36
        loginInputStackTrailingConstraint.constant = 36
        loginInputStackBottomConstraint.constant = 40
        loginInputStackTopConstraint.constant = 144
        if (isLoginActive == true){
            switchViewButton.setTitle("Opprette bruker?", for: .normal)
        } else {
            switchViewButton.setTitle("Allerede bruker?", for: .normal)
        }
    }
    
    func keyboardWillShow() {
        print("Keyboard will show")
        activateLoginView()
    }
    
    func activateLoginView() {
        isViewActive = true
        activateBannerStack()
        activateWhitePanelStack()
        activateLoginInputStack()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func activateBannerStack() {
        bannerStackTopConstraint.constant = 20
    }
    
    func activateWhitePanelStack() {
        whitePanelStackHeightConstraint.isActive = false
        whitePanelStackTopConstraint.isActive = true
        whitePanelStackLeadingConstraint.constant = 0
        whitePanelStackTrailingConstraint.constant = 0
    }
    
    func activateLoginInputStack() {
        loginInputStackBottomConstraint.isActive = false
        loginInputStackTopConstraint.isActive = true
        if (isLoginActive == true){
            //Forgot password
            switchViewButton.setTitle("Glemt passord?", for: .normal)
        } else {
            if (hasRegistrationBegun == false) {
                //Already user
                switchViewButton.setTitle("", for: .normal)
            } else {
                //Navigate back
                switchViewButton.setTitle("Tilbake", for: .normal)
            }
        }
    }
    
    
    func keyboardWillHide() {
        print("Keybord will hide")
    }

    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let gesture = sender.translation(in: view)
        self.view.endEditing(true)
        print(gesture.y)
        gestureWhitePanel = gesture.y/whitePanelLeadingOffset!
        gestureBanner = (gesture.y/bannerStackTopOffset!)*4
        
        whitePanelStackTopConstraint.constant = gesture.y

        if (gestureWhitePanel! < whitePanelLeadingOffset! && isViewActive == true){
            whitePanelStackLeadingConstraint.constant = gesture.y/whitePanelLeadingOffset!
            whitePanelStackTrailingConstraint.constant = gesture.y/whitePanelTrailingOffset!
        }
        
        if (gestureBanner! < 40 && isViewActive == true) {
            bannerStackTopConstraint.constant = (gesture.y/bannerStackTopOffset!)*4
            bannerStackTopConstraint.constant += 20
        }
        
        if (gesture.y > 104) {
            loginInputStackTopConstraint.constant = gesture.y
            loginInputStackTopConstraint.constant += 20
        }
        
        if sender.state == UIGestureRecognizerState.ended {
            print("Ended movement")
            
            if (gesture.y < self.view.bounds.height/2) {
                print("Return to active stance")
                self.initialLoginView()
                self.activateLoginView()
                
            } else if (gesture.y >= self.view.bounds.height/2){
                print("Change to initial stance")
                self.initialLoginView()
                UIView.animate(withDuration: 0.5, animations: { 
                    self.view.layoutIfNeeded()
                })
            }
            sender.setTranslation(CGPoint.zero, in: self.view)

        }
    }
}
