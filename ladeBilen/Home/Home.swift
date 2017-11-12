//
//  homeViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import MapKit


class Home: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var mapWindow: MKMapView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var nearestButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var buttonStackConstraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var buttonStackConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var settingsStackConstraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var settingsStackConstraintLeading: NSLayoutConstraint!
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var settingsStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeButtons()
        checkButtonFlip()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(defaults.integer(forKey: "flip"))
        checkButtonFlip()
    }
    
    func initializeButtons(){
        searchButton.layer.cornerRadius = 25
        searchButton.clipsToBounds = true
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(24, 24, 24, 24)
        
        favoritesButton.layer.cornerRadius = 25
        favoritesButton.clipsToBounds = true
        favoritesButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        
        nearestButton.layer.cornerRadius = 25
        nearestButton.clipsToBounds = true
        nearestButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        settingsButton.layer.cornerRadius = 25
        settingsButton.clipsToBounds = true
        settingsButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
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
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toSearch", sender: self)

    }
    
    @IBAction func favoritesButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toFavorites", sender: self)
    }
    
    @IBAction func nearestButtonClicked(_ sender: Any) {
    }
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    func checkButtonFlip(){
        if (defaults.integer(forKey: "flip") == 2){
            //Hvis button er satt til venstre er value i flip 2 og dermed så aktiverer den de constrintene som flytter stacken
            buttonStackConstraintTrailing.isActive = false
            buttonStackConstraintLeading.isActive = true
            
            settingsStackConstraintTrailing.isActive = true
            settingsStackConstraintLeading.isActive = false
            self.view.layoutIfNeeded()

        } else {
            //Hvis den er enten 0 eller 1 så står/flyttes de på/til default possisjon
            buttonStackConstraintTrailing.isActive = true
            buttonStackConstraintLeading.isActive = false
            
            settingsStackConstraintTrailing.isActive = false
            settingsStackConstraintLeading.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}
