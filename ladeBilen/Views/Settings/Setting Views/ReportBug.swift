//
//  ReportBug.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit
import AudioToolbox

class ReportBug: UIViewController, UITextViewDelegate {
    
    var app: App!
    
    let placeholder = "Prøv å skriv hva som skjedde, og hvordan man kan gjenskape feilen"

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        //whitePanel.layer.cornerRadius = 20
        
        
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight : Int = Int(keyboardSize.height)
            bottomConstraint.constant = CGFloat(keyboardHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func backgroundWasTapped(_ sender: UITapGestureRecognizer) {
        backgroundView.removeFromSuperview()
        textView.becomeFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

    @IBAction func sendButtonClicked(_ sender: UIBarButtonItem) {
        if !textView.text.isEmpty {
            let alert = UIAlertController(title: "Rapporter Feil", message: "Er du klar til å levere inn en rapport?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: { action in
                AudioServicesPlaySystemSound(Constants.VIBRATION_STRONG)
                self.textViewDidEndEditing(self.textView)
                self.app.submitBugToDatabase(reportedText: self.textView.text)
                self.textView.text = "Takk for at du sendte en rapport, vi vil gjennomgå denne snarest. Dersom vi lurer på noe vil vi ta kontakt via email."
                self.textView.textColor = UIColor.lightGray
                
            }))
            alert.addAction(UIAlertAction(title: "Avbryt", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
