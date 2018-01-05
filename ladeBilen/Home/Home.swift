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



class Home: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager = CLLocationManager()
    var isInitial: Bool = true
    var id: Int?
    var stations:[Station] = []
    let database = Database()
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredStations: [Station]?
    var selectedStationSearch: Station?

    @IBOutlet weak var tableViewStack: UIStackView!
    @IBOutlet var tableView: UITableView!
    
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
        tableView.delegate = self
        tableView.dataSource = self
        isInitial = true
        initializeMap()
        initializeButtons()
        initializeView()

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        self.addAnnotationsToMap()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = filteredStations else {
            return GlobalResources.stations.count
        }
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let result = filteredStations {
            cell.textLabel!.text = result[indexPath.row].name
        } else {
            cell.textLabel!.text = GlobalResources.stations[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = filteredStations![indexPath.row].id
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            tableViewStack.isHidden = false
            filteredStations = GlobalResources.stations.filter { filteredStations in
                return (filteredStations.name?.lowercased().contains(searchText.lowercased()))!
            }
        } else {
            tableViewStack.isHidden = true
            filteredStations = GlobalResources.stations
        }
        tableView.reloadData()
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

