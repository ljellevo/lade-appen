//
//  ViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapWindow: MKMapView!
    
    @IBOutlet weak var favouritesButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var nearestButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeButtons()
    }
    
    func initializeButtons(){
        settingsButton.layer.cornerRadius = 25
        settingsButton.clipsToBounds = true
        settingsButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        nearestButton.layer.cornerRadius = 25
        nearestButton.clipsToBounds = true
        nearestButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        favouritesButton.layer.cornerRadius = 25
        favouritesButton.clipsToBounds = true
        favouritesButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        
        searchButton.layer.cornerRadius = 25
        searchButton.clipsToBounds = true
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(24, 24, 24, 24)
    }
    
    override func viewWillLayoutSubviews() {
        positionLegalMapLabel()
    }
    
    func positionLegalMapLabel() {
        //Må høre med apple om man kan flytte "Legal" linken til et separert view. Typ "About/legal" view elns. Nedenfor er metoden for å hente ut labelen + for å flytte den.
        let legalMapLabel = self.mapWindow.subviews[1]
        
        
        //legalMapLabel.frame.origin = CGPoint(x: 20, y: 20)
        
        legalMapLabel.frame.origin = CGPoint(x: self.mapWindow.bounds.size.width / 2, y: legalMapLabel.frame.origin.y)

    }
}

