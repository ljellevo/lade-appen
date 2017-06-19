//
//  welcomeNewViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 19.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class welcomeNewViewController: UIViewController, UITextFieldDelegate {

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
    
    @IBOutlet weak var statusBarStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialButtonSetup()
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

    func initialButtonSetup() {
        initialButtonStackTrailingConstraint.isActive = false
        grassStackTopConstraint.isActive = false
        whitePanelStackTopConstraint.isActive = false
        loginStackTopConstraint.isActive = false
        statusBarStackView.isHidden = true
        bannerStackTopConstraint.constant = 188
        iconStackLeadingConstraint.constant = -60
        grassStackHeightConstraint.constant = 120
        whitePannelStackHeightConstraint.constant = 0
        whitePanel.layer.cornerRadius = 20


        
        loginButton.layer.shadowOpacity = 0.2
        registerButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        registerButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        
        emailTextField.setBottomBorderGray()
        passwordTextField.setBottomBorderGray()
        loginStack.alpha = 0.0
        loginStack.isHidden = true
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
        
        iconStackLeadingConstraint.constant = 400
        UIView.animate(withDuration: 1.25) {
            self.view.layoutIfNeeded()
        }
        self.loginStack.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1250)) {
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
        print("Keyboard will show")
        grassStackHeightConstraint.isActive = false
        grassStackTopConstraint.isActive = true
        grassStackTopConstraint.constant = 0
        whitePannelStackHeightConstraint.isActive = false
        whitePanelStackTopConstraint.isActive = true
        whitePanelStackTopConstraint.constant = 0
        whitePanelStackLeadingConstraint.constant = 0
        whitePanelStackTrailingConstraint.constant = 0
        loginStackBottomConstraint.isActive = false
        loginStackTopConstraint.isActive = true
        loginStackTopConstraint.constant = 150
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
        statusBarStackView.isHidden = false
        
        
        
    }
    
    func keyboardWillHide(){
        print("Keyboard will hide")
        
    }
}
