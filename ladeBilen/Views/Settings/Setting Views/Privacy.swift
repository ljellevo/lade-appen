//
//  Privacy.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20/01/2019.
//  Copyright © 2019 Ludvig Ellevold. All rights reserved.
//

import UIKit

class Privacy: UIViewController {

    @IBOutlet weak var sendDataButton: LoadingUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendDataButton.layer.cornerRadius = 20
    }
    
    @IBAction func sendDataButton(_ sender: UIButton) {
        sendDataButton.showLoading()
        sendDataButton.hideLoading(clearTitle: false)
    }
}
