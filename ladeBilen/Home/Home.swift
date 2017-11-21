//
//  homeViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class Home: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    let defaults = UserDefaults.standard
    var stations:[Station] = []

    
    
    @IBOutlet weak var mapWindow: MKMapView!
    @IBOutlet weak var nearestButton: UIButton!
    
    @IBOutlet weak var buttonStackConstraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var buttonStackConstraintLeading: NSLayoutConstraint!
    
    @IBOutlet weak var buttonsStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMap()
        initializeButtons()
        checkButtonFlip()
        getStationsFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(defaults.integer(forKey: "flip"))
        checkButtonFlip()
    }
    
    func initializeButtons(){
        nearestButton.layer.cornerRadius = 25
        nearestButton.clipsToBounds = true
        nearestButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
    }
    
    func initializeMap(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapWindow.showsUserLocation = true
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

    
    @IBAction func nearestButtonClicked(_ sender: Any) {
        print("Clicked")
        
    }
    
    func getStationsFromDatabase(){
        let ref = FIRDatabase.database().reference()
        ref.child("stations").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                for children in dictionary{
                    let eachStation = children.value as? [String: AnyObject]
                    self.createStationStructs(eachStation: eachStation!)
                }
                print("Done")
                self.addAnnotationsToMap()
            }
        }, withCancel: nil)
    }
    
    func createStationStructs(eachStation: [String: AnyObject]){
        let station = Station(dictionary: eachStation)
        self.stations.append(station)
    }
    
    func addAnnotationsToMap(){
        for children in stations{
            var position = children.position
            position = position?.replacingOccurrences(of: "(", with: "")
            position = position?.replacingOccurrences(of: ")", with: "")
            let positionArray = position!.components(separatedBy: ",")
            let lat = Double(positionArray[0])
            let lon = Double(positionArray[1])
            
            let coordinates = CLLocationCoordinate2D(latitude:lat!, longitude:lon!)
        
            let annotation = Annotation(title: children.name!, coordinate: coordinates, street: children.street!)
            mapWindow.addAnnotation(annotation)
            
        }
    }

    
    func checkButtonFlip(){
        /*
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
         
         
         
         -------KLIPPEBRETT--------

 */
    }
}
