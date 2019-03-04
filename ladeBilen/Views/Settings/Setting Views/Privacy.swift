//
//  Privacy.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20/01/2019.
//  Copyright © 2019 Ludvig Ellevold. All rights reserved.
//

import UIKit
import FirebaseAuth

class Privacy: UIViewController {
    
    var app: App!

    @IBOutlet weak var sendDataButton: LoadingUIButton!
    @IBOutlet weak var deleteUserButton: LoadingUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendDataButton.layer.cornerRadius = 20
        deleteUserButton.layer.cornerRadius = 20
    }
    
    @IBAction func sendDataButton(_ sender: UIButton) {
        sendDataButton.showLoading()
        app.sendAllData { error in
            if error != nil {
                self.sendDataButton.hideLoading(clearTitle: false)
                let alert = UIAlertController(title: "Ops!", message: "Dessverre er tjenesten ikke tilgjengelig for øyeblikket, vennligst prøv igjen senere.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.sendDataButton.hideLoading(clearTitle: false)
            let alert = UIAlertController(title: "Sendt", message: "En epost med all informasjonen har blitt sendt.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteUserButton(_ sender: UIButton) {
        deleteUserButton.showLoading()
        let alert = UIAlertController(title: "Er du sikker?", message: "All data som er lagret og din bruker vil bli slettet.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Slett meg", style: UIAlertAction.Style.destructive, handler: { action in
            self.app.deleteUser(done: { error in
                if error != nil {
                    self.deleteUserButton.hideLoading(clearTitle: false)
                    let alert = UIAlertController(title: "Ops!", message: "Dessverre er tjenesten ikke tilgjengelig for øyeblikket, vennligst prøv igjen senere.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                /*
                 do{
                    try Auth.auth().signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                    controller.app = App()
                    self.present(controller, animated: false, completion: { () -> Void in
                    })
                 } catch {
                    print ("Error")
                 }
                 */
            })
        }))
        alert.addAction(UIAlertAction(title: "Avbryt", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
