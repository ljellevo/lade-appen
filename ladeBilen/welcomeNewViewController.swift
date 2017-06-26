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
    var loginStackBottomOffset: CGFloat = 0.0
    var whiteStackLeadingOffset: CGFloat = 0.0
    var whiteStackTrailingOffset: CGFloat = 0.0


    

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet var initialButtonStack: UIStackView!
        @IBOutlet var initialButtonStackCenterConstraint: NSLayoutConstraint!
        @IBOutlet var initialButtonStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var initialButtonStackLeadingConstraint: NSLayoutConstraint!

    @IBOutlet var bannerStack: UIStackView!
        @IBOutlet var bannerStackCenterConstraint: NSLayoutConstraint!
        @IBOutlet var bannerStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var bannerStackTopConstraint: NSLayoutConstraint!
    

    

    
    @IBOutlet var loginStack: UIStackView!
        @IBOutlet var emailTextField: UITextField!
        @IBOutlet var passwordTextField: UITextField!
        @IBOutlet var loginStackBottomConstraint: NSLayoutConstraint!
        @IBOutlet var loginStackTopConstraint: NSLayoutConstraint!
        @IBOutlet var loginStackLeadingConstraint: NSLayoutConstraint!
        @IBOutlet var loginStackTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var whitePanelStack: UIStackView!
        @IBOutlet var whitePanel: UIView!
        @IBOutlet var whitePannelStackHeightConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackTopConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var whitePanelStackLeadingConstraint: NSLayoutConstraint!
    
    
    
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
        initalizeInitButtonStack()
        initializeLoginTextFieldStack()
        
    }
    
    func initalizeInitButtonStack() {
        initialButtonStackTrailingConstraint.isActive = false
        initialButtonStackLeadingConstraint.isActive = false
        initialButtonStackCenterConstraint.isActive = true
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

    func initializeWhitePanelStack() {
        whitePannelStackHeightConstraint.isActive = true
        whitePanelStackTopConstraint.isActive = false
        whitePannelStackHeightConstraint.constant = 0
        whitePanel.layer.cornerRadius = 20
    }
    
    
    func initializeBannerStack() {
        bannerStackTopConstraint.constant = 188
    }
    

    
    
    

    @IBAction func initialLoginButtonClicked(_ sender: UIButton) {
        loadLoginConfig()
    }
    
    
    func loadLoginConfig(){
        initialButtonStackCenterConstraint.isActive = false
        //initialButtonStackTrailingConstraint.isActive = true
        initialButtonStackLeadingConstraint.isActive = true
        bannerStackTopConstraint.constant = 40
        whitePanelStackLeadingConstraint.constant = 16
        whitePanelStackTrailingConstraint.constant = 16
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }

        self.loginStack.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
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
        
        whiteStackLeadingOffset = whitePanelStackLeadingConstraint.constant
        whiteStackTrailingOffset = whitePanelStackTrailingConstraint.constant
    }
    
    func keyboardWillShow(notification: NSNotification){
        if (!keyboardIsShown){
            keyboardIsShown = true
            activateLoginConfig()
        }
    }
    
    func activateLoginConfig() {
        activateWhitePanelStack()
        activateLoginStack()
        
        
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
        loginStackBottomOffset = loginStackBottomConstraint.constant
    }
    
    func keyboardWillHide(){
        print("Keyboard will hide")
        keyboardIsShown = false
        
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func dragToDismiss(_ sender: UIPanGestureRecognizer) {
        let gesture = sender.translation(in: view)
        self.view.endEditing(true)
        print(-gesture.x)
        print(self.view.bounds.width/2)

        whitePanelStackTopConstraint.constant = gesture.y
        /*
        if (whitePanelStackLeadingConstraint.constant < whiteStackLeadingOffset && whitePanelStackTrailingConstraint.constant < whiteStackTrailingOffset) {
            whitePanelStackLeadingConstraint.constant = whitePanelStackTopConstraint.constant/whiteStackLeadingOffset
            whitePanelStackTrailingConstraint.constant = whitePanelStackTopConstraint.constant/whiteStackTrailingOffset
        }
 */
        
        whitePanelStackLeadingConstraint.constant = whitePanelStackTopConstraint.constant/whiteStackLeadingOffset
        whitePanelStackTrailingConstraint.constant = whitePanelStackTopConstraint.constant/whiteStackTrailingOffset
        
        
        if (whitePanelStackTopConstraint.constant > 150) {
            loginStackTopConstraint.constant = whitePanelStackTopConstraint.constant + 20

        }
        whitePanelStackLeadingConstraint.constant = gesture.x
        whitePanelStackTrailingConstraint.constant = -gesture.x
        whitePanelStackLeadingConstraint.constant += 16
        whitePanelStackTrailingConstraint.constant += 16
        loginStackLeadingConstraint.constant = gesture.x
        loginStackTrailingConstraint.constant = -gesture.x
        loginStackLeadingConstraint.constant += 36
        loginStackTrailingConstraint.constant += 36

        if sender.state == UIGestureRecognizerState.ended {
            print("Ended")
            
            if (-gesture.x > self.view.bounds.width/2) {
                print("Back")
                initialViewSetup()
                sender.setTranslation(CGPoint.zero, in: self.view)
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                
            } else if (whitePanelStackTopConstraint.constant > self.view.bounds.height/4) {
                
                deactivateWhitePanelStack()
                deacvtivateLoginStack()
                loadLoginConfig()
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else {
                activateLoginConfig()
            }
        }
    }
    
    func deacvtivateLoginStack() {
        loginStackTopConstraint.isActive = false
        loginStackBottomConstraint.isActive = true
    }

    
    func deactivateWhitePanelStack() {
        whitePanelStackTopConstraint.isActive = false
        whitePannelStackHeightConstraint.isActive = true
    }
    
}
