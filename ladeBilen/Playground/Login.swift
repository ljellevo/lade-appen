//
//  loginViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController, UITextFieldDelegate {
    
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

        @IBOutlet var loginButton: UIButton!
        @IBOutlet var switchViewButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        switchViewButton.setTitle("Opprette bruker?", for: .normal)
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        if inputOneTextField.text!.isEmpty || inputTwoTextField.text!.isEmpty {
            if(inputOneTextField.text!.isEmpty){
                inputOneTextField.setBottomBorderRed()
            } else {
                inputTwoTextField.setBottomBorderRed()
            }
        } else {
            FIRAuth.auth()?.signIn(withEmail: inputOneTextField.text!, password: inputTwoTextField.text!, completion: { (user, error) in
                if (error != nil) {
                    self.inputOneTextField.setBottomBorderRed()
                    self.inputTwoTextField.setBottomBorderRed()
                } else {
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
            })
        }
    }
    
    @IBAction func switchButtonClicked(_ sender: UIButton) {
        if(isViewActive == true){
            print("Glemt passord")
        } else {
            print("Opprett bruker")
        }
    }
    
    func initializeBannerStack() {
        bannerStackTopConstraint.isActive = true
        bannerStackTopConstraint.constant = 40
        bannerStackTopOffset = bannerStackTopConstraint.constant
    }
    
    func initializeWhitePanelStack() {
        whitePanelStackTopConstraint.constant = self.view.bounds.height/2
        whitePanelStackLeadingConstraint.constant = 16
        whitePanelStackTrailingConstraint.constant = 16
        whitePanelStackBottomConstraint.constant = -17
        whitePanelLeadingOffset = whitePanelStackLeadingConstraint.constant
        whitePanelTrailingOffset = whitePanelStackTrailingConstraint.constant
    }
    
    func initializeLoginInputStack() {
        loginInputStackLeadingConstraint.constant = 36
        loginInputStackTrailingConstraint.constant = 36
        loginInputStackTopConstraint.constant = UIScreen.main.bounds.height * 0.55
    }
    
    func keyboardWillShow() {
        print("Keyboard will show")
        activateLoginView()
    }
    
    func activateLoginView() {
        isViewActive = true
        switchViewButton.setTitle("Glemt passord?", for: .normal)
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
        whitePanelStackTopConstraint.constant = 0
        whitePanelStackLeadingConstraint.constant = 0
        whitePanelStackTrailingConstraint.constant = 0
    }
    
    func activateLoginInputStack() {
        loginInputStackTopConstraint.constant = 120
    }
    
    
    func keyboardWillHide() {
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
        
        if sender.state == UIGestureRecognizerState.ended {
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
    
}
