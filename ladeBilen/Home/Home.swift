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

var stations:[Station] = []


class Home: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var isInitial: Bool = true
    var id: Int?

    @IBOutlet weak var mapWindow: MKMapView!
    @IBOutlet weak var nearestButton: UIButton!
    @IBOutlet weak var buttonStackConstraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var buttonStackConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    @IBOutlet var infoView: UIView!
        @IBOutlet weak var infoPaneStack: UIStackView!
            @IBOutlet weak var nameLabel: UILabel!
            @IBOutlet weak var streetLabel: UILabel!
            @IBOutlet weak var detailsButton: UIButton!
            @IBOutlet weak var infoPaneStackBottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMap()
        initializeButtons()
        initializeView()
        getStationsFromDatabase()
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
        mapWindow.delegate = self

    }
    
    func initializeView(){
        infoPaneStack.alpha = 0.0
        infoPaneStackBottomConstraint.constant = -70
        infoView.isHidden = true

    }

    
    @IBAction func nearestButtonClicked(_ sender: Any) {
        print("Clicked")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            var station: Station?
            for i in 0..<stations.count{
                if stations[i].id == self.id {
                    station = stations[i]
                    break
                }
            }
            if let nextViewController = segue.destination as? Details{
                nextViewController.station = station
            }
        }
    }
    
    @IBAction func detailsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    func getStationsFromDatabase(){
        let ref = FIRDatabase.database().reference()
        ref.child("stations").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                for children in dictionary{
                    let eachStation = children.value as? [String: AnyObject]
                    self.createStationStructs(eachStation: eachStation!)
                }
                self.addAnnotationsToMap()
            }
        }, withCancel: nil)
    }
    
    func createStationStructs(eachStation: [String: AnyObject]){
        let station = Station(dictionary: eachStation)
        stations.append(station)
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
        
            let annotation = Annotation(title: children.name!, subtitle: children.street!, id: children.id!, coordinate: coordinates)
            mapWindow.addAnnotation(annotation)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let anno = view.annotation as? Annotation {
            id = anno.id!
            print(id!)
            nameLabel.text = anno.title
            streetLabel.text = anno.subtitle
            infoView.isHidden = false
            infoPaneStackBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.infoPaneStack.alpha = 1.0
                self.infoView.layoutIfNeeded()
            }
        } else {
            return
        }
    }
    


    

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        infoPaneStackBottomConstraint.constant = -70
        UIView.animate(withDuration: 0.5) {
            self.infoPaneStack.alpha = 0.0
            self.infoView.layoutIfNeeded()
        }
        self.infoView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if isInitial == true {
            let regionRadius = CLLocationDistance(1500)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, regionRadius, regionRadius)
            mapView.setRegion( coordinateRegion, animated: true)
            isInitial = false
        } else {
            return
        }
    }

}

