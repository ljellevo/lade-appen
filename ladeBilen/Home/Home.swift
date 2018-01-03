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
    var isInitial: Bool = true
    var id: Int?
    var stations:[Station] = []
    let database = Database()

    @IBOutlet weak var mapWindow: MKMapView!
    @IBOutlet weak var nearestButton: UIButton!
    @IBOutlet weak var buttonStackConstraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var buttonStackConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var infoViewPannel: UIView!
    @IBOutlet weak var infoPaneStack: UIStackView!
            @IBOutlet weak var nameLabel: UILabel!
            @IBOutlet weak var streetLabel: UILabel!
            @IBOutlet weak var detailsButton: UIButton!
            @IBOutlet weak var infoPaneStackBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isInitial = true
        initializeMap()
        initializeButtons()
        initializeView()

        
        database.getStationsFromDatabase() {
            print("Found stations")
            //GlobalResources.stations = self.stations
            self.addAnnotationsToMap()
        }
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
        infoViewPannel.layer.cornerRadius = 20
        infoViewPannel.layer.borderWidth = 0.5
        infoViewPannel.layer.borderColor = UIColor.lightGray.cgColor
        infoViewPannel.layer.masksToBounds = true
        infoPaneStack.alpha = 0.0
        infoPaneStackBottomConstraint.constant = -70
        infoView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            var station: Station?
            for i in 0..<GlobalResources.stations.count{
                if GlobalResources.stations[i].id == self.id {
                    station = GlobalResources.stations[i]
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
    
    /*
    func getStationsFromDatabase(finished: @escaping () -> Void){
        let ref = FIRDatabase.database().reference()
        ref.child("stations").observe(.value, with: { (snapshot) in
            DispatchQueue.global().async {
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    for children in dictionary{
                        let eachStation = children.value as? [String: AnyObject]
                        let station = Station(dictionary: eachStation!)
                        self.stations.append(station)
                    }
                }
                DispatchQueue.main.async {
                    finished()
                }
            }
        }, withCancel: nil)
    }
 */
 
    

    
    func addAnnotationsToMap(){
        for children in GlobalResources.stations{
                var position = children.position
                position = position?.replacingOccurrences(of: "(", with: "")
                position = position?.replacingOccurrences(of: ")", with: "")
                let positionArray = position!.components(separatedBy: ",")
                let lat = Double(positionArray[0])
                let lon = Double(positionArray[1])
                
                let coordinates = CLLocationCoordinate2D(latitude:lat!, longitude:lon!)
                
                let annotation = Annotation(title: children.name!, subtitle: children.street!, id: children.id!, coordinate: coordinates)
                self.mapWindow.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let anno = view.annotation as? Annotation {
            id = anno.id!
            print(id!)
            nameLabel.text = anno.title
            streetLabel.text = anno.subtitle
            infoView.isHidden = false
            infoPaneStackBottomConstraint.constant = 16
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

