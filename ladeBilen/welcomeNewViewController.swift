//
//  welcomeNewViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 19.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class welcomeNewViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardIsShown: Bool = false
    

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var initialButtonStack: UIStackView!
        @IBOutlet weak var initialButtonStackCenterConstraint: NSLayoutConstraint!
        @IBOutlet weak var initialButtonStackTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var bannerStack: UIStackView!
        @IBOutlet weak var bannerStackCenterConstraint: NSLayoutConstraint!
        @IBOutlet weak var bannerStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet weak var bannerStackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconStack: UIStackView!
        @IBOutlet weak var iconStackLeadingConstraint: NSLayoutConstraint!
        @IBOutlet weak var iconStackCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var grassStack: UIStackView!
        @IBOutlet weak var grassStackHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var grassStackTopConstraint: NSLayoutConstraint!
    

    
    @IBOutlet weak var loginStack: UIStackView!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var loginStackBottomConstraint: NSLayoutConstraint!
        @IBOutlet weak var loginStackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var whitePanelStack: UIStackView!
        @IBOutlet weak var whitePanel: UIView!
        @IBOutlet weak var whitePannelStackHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var whitePanelStackTopConstraint: NSLayoutConstraint!
        @IBOutlet weak var whitePanelStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet weak var whitePanelStackLeadingConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
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
    

    func initialViewSetup() {
        initializeWhitePanelStack()
        initializeBannerStack()
        initializeIconStack()
        initializeGrassStack()
        initalizeInitButtonStack()
        initializeLoginTextFieldStack()
    }
    
    func initalizeInitButtonStack() {
        initialButtonStackTrailingConstraint.isActive = false
        loginButton.layer.shadowOpacity = 0.2
        registerButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        registerButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    func initializeLoginTextFieldStack() {
        loginStackTopConstraint.isActive = false
        emailTextField.setBottomBorderGray()
        passwordTextField.setBottomBorderGray()
        loginStack.alpha = 0.0
        loginStack.isHidden = true
    }
    
    func initializeGrassStack() {
        grassStackHeightConstraint.isActive = true
        grassStackTopConstraint.isActive = false
        grassStackHeightConstraint.constant = 120
    }
    
    func initializeWhitePanelStack() {
        whitePanelStackTopConstraint.isActive = false
        whitePannelStackHeightConstraint.constant = 0
        whitePanel.layer.cornerRadius = 20
    }
    
    func initializeBannerStack() {
        bannerStackTopConstraint.constant = 188
    }
    
    func initializeIconStack() {
        iconStackLeadingConstraint.constant = -60
    }
    
    
    

    @IBAction func initialLoginButtonClicked(_ sender: UIButton) {
        loadLoginConfig()
    }
    
    
    func loadLoginConfig(){
        initialButtonStackCenterConstraint.isActive = false
        initialButtonStackTrailingConstraint.isActive = true
        bannerStackTopConstraint.constant = 40
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }

        self.loginStack.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            self.grassStackHeightConstraint.constant = 300
            self.whitePannelStackHeightConstraint.constant = 287
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                    UIView.animate(withDuration: 0.5) {
                        self.loginStack.alpha = 1.0
                    }
                })
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        if (!keyboardIsShown){
            keyboardIsShown = true
            activateGrassStack()
            activateWhitePanelStack()
            activateLoginStack()
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func activateGrassStack() {
        grassStackHeightConstraint.isActive = false
        grassStackTopConstraint.isActive = true
        grassStackTopConstraint.constant = -20
    }
    
    func activateWhitePanelStack() {
        whitePannelStackHeightConstraint.isActive = false
        whitePanelStackTopConstraint.isActive = true
        whitePanelStackTopConstraint.constant = 0
        whitePanelStackLeadingConstraint.constant = 0
        whitePanelStackTrailingConstraint.constant = 0
    }
    
    func activateLoginStack() {
        loginStackBottomConstraint.isActive = false
        loginStackTopConstraint.isActive = true
        loginStackTopConstraint.constant = 150
    }
    
    func keyboardWillHide(){
        print("Keyboard will hide")
        keyboardIsShown = false
        
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func dragToDismiss(_ sender: UIPanGestureRecognizer) {
        let gesture = sender.translation(in: view)
        print("x: ", gesture.x)
        print("y: ", gesture.y)
        
            //Swipe nedover
        self.view.endEditing(true)
        //grassStack.center = CGPoint(x:view.center.x, y:view.center.y + gesture.y)
        //whitePanelStack.center = CGPoint(x:view.center.x, y:view.center.y + gesture.y)
        whitePanelStackTopConstraint.constant = gesture.y
        //loginStack.center = CGPoint(x:view.center.x, y:view.center.y + gesture.y)
        
        if sender.state == UIGestureRecognizerState.ended {
            print("Ended")
            if (whitePanelStackTopConstraint.constant > 20) {
                initializeGrassStack()
                initializeWhitePanelStack()
                loadLoginConfig()
            }
        
        
        }

        
            
        
        //sender.setTranslation(CGPoint.zero, in: self.view)


    }
    
    func deacvtivateLoginStack() {
        
    }
    
}
