//
//  About.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class About: UIViewController {

    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var whitePanel: UIView!
    
    var aboutString: String = "Laget av:\rLudvig og Hågen Ellevold\r\rwww.ladeappen.no\r\r\rInformasjon om stasjoner levert av NOBIL:\rhttp://info.nobil.no\r\rCloud løsning levert av Firebase:\rhttps://firebase.google.com\r\rAppen bruker Disk rammeverket av:\rhttps://github.com/saoudrizwan\rDette rammeverket er lisensiert under MIT License.\r\r\rVersjon 1.0 Alpha."
   
    override func viewDidLoad() {
        super.viewDidLoad()
        whitePanel.layer.cornerRadius = 20
        aboutLabel.text = aboutString

    }


}
