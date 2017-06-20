//
//  playgroundViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class playgroundViewController: UIViewController {

    @IBOutlet weak var carOneHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var carOneLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var carTwoLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var carThreeLeadingConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        self.carOneLeadingConstraint.constant = 0 - self.carOneHeightConstraint.constant
        self.carTwoLeadingConstraint.constant = 0 - self.carOneHeightConstraint.constant
        self.carThreeLeadingConstraint.constant = 0 - self.carOneHeightConstraint.constant

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carAnimation()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func carAnimation(){
        UIView.animate(withDuration: 2, delay: 0, options:[.allowUserInteraction, .repeat, .curveLinear], animations: {
            self.carOneLeadingConstraint.constant += self.view.bounds.width + self.carOneHeightConstraint.constant
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        UIView.animate(withDuration: 1.5, delay: 0.9, options:[.allowUserInteraction, .repeat, .curveLinear], animations: {
            self.carTwoLeadingConstraint.constant += self.view.bounds.width + self.carOneHeightConstraint.constant
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        UIView.animate(withDuration: 2.5, delay: 1.5, options:[.allowUserInteraction, .repeat, .curveLinear], animations: {
            self.carThreeLeadingConstraint.constant += self.view.bounds.width + self.carOneHeightConstraint.constant
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        
        
        
        
    }
    
    


    



}
