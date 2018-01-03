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
    
    let database = Database()
    
    let placeholder = "Vennligst skriv utfyllende både hva som skjedde og hvilke handlinger som du utførte før feilen oppstod. Ved misbruk vil du risikere å bli utestengt."

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var whitePanel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        whitePanel.layer.cornerRadius = 20
        
        textView.text = placeholder
        textView.textColor = UIColor.lightGray

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }

    @IBAction func sendButtonClicked(_ sender: UIBarButtonItem) {
        if !textView.text.isEmpty {
            let alert = UIAlertController(title: "Rapporter Feil", message: "Er du klar til å levere inn en rapport?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { action in
                AudioServicesPlaySystemSound(1520)
                self.textViewDidEndEditing(self.textView)
                self.database.submitBugReport(reportedText: self.textView.text)
                self.textView.text = "Takk for at du sendte en rapport, vi vil gjennomgå denne snarest. Dersom vi lurer på noe vil vi ta kontakt via email."
                self.textView.textColor = UIColor.lightGray
                
            }))
            alert.addAction(UIAlertAction(title: "Tilbake", style: UIAlertActionStyle.cancel, handler: nil))
            

            self.present(alert, animated: true, completion: nil)
        }
    }
}
