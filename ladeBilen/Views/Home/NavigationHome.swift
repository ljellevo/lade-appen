//
//  navgViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class NavigationHome: UINavigationController {
    
    var app: App?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NavHomeVDL")
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("NavHome")
        let navVC = segue.destination as! NavigationHome
        let homeVC = navVC.viewControllers.first as! Home
        
        homeVC.app = app!
    }
}
