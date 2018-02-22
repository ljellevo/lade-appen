//
//  ChangeUserInfo.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class ChangeUserInfo: UIViewController{
    
    let database = Database()
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var whitePanelCorner: UIView!
    
    var rowIndex: Int?
    var placeholder: String?
    let nameInfoLabel: String = "Ditt navn er ikke synlig for andre brukere"
    let emailInfoLabel: String = "Din epost brukes kun til pålogging og nullstilling av passord"


    override func viewDidLoad() {
        super.viewDidLoad()
        textField.setBottomBorder()
        whitePanel.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        if rowIndex == 0 {
            textField.text = GlobalResources.user?.firstname
            informationLabel.text = nameInfoLabel
        } else  {
            textField.text = GlobalResources.user?.lastname
            informationLabel.text = nameInfoLabel
        }
    
    }
    
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if rowIndex == 0 {
            GlobalResources.user?.firstname = textField.text
            database.updateUser()
            informationLabel.text = "Fornavn er oppdatert"
        } else {
            GlobalResources.user?.lastname = textField.text
            database.updateUser()
            informationLabel.text = "Etternavn er oppdatert"
        }
    }
    


}
