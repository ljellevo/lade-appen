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
    
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    
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
    
    
    
}
