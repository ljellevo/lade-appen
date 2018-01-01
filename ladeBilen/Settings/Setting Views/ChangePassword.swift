//
//  ChangePassword.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class ChangePassword: UIViewController {

    @IBOutlet weak var oldPassord: UITextField!
    
    @IBOutlet weak var retypeOldPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPassord.setBottomBorder()
        retypeOldPassword.setBottomBorder()
        newPassword.setBottomBorder()
        changeButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func changeButton(_ sender: UIButton) {
        
    }


}
