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
import Disk



class Home: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource{

    var app: App?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var isInitial: Bool = true
    var id: Int?
    var stations:[Station] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredStations: [Station]?
    var selectedStationSearch: Station?


    @IBOutlet weak var tableViewStack: UIStackView!
    @IBOutlet weak var tableViewStackBottomConstraint: NSLayoutConstraint!
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
        filteredStations = app!.filteredStations
        mapWindow.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        isInitial = true
        initializeMap()
        initializeButtons()
        initializeView()

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Søk"
        setupNavigationBar()
        self.definesPresentationContext = true
    }
    
    


    
    func setupNavigationBar() {
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchController.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredStations = app!.filteredStations
        self.addAnnotationsToMap()
        searchController.searchBar.sizeToFit()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStations!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let result = filteredStations {
            cell.textLabel!.text = result[indexPath.row].name
        } else {
            cell.textLabel!.text = filteredStations![indexPath.row].name
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
            filteredStations = filteredStations!.filter { filteredStations in
                return (filteredStations.name?.lowercased().contains(searchText.lowercased()))!
            }
        } else {
            tableViewStack.isHidden = true
            filteredStations = app?.filteredStations
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
    

    

    func addAnnotationsToMap(){
        mapWindow.removeAnnotations(mapWindow.annotations)
        for children in filteredStations!{
            var position = children.position
            position = position?.replacingOccurrences(of: "(", with: "")
            position = position?.replacingOccurrences(of: ")", with: "")
            let positionArray = position!.components(separatedBy: ",")
            let lat = Double(positionArray[0])
            let lon = Double(positionArray[1])
            let coordinates = CLLocationCoordinate2D(latitude:lat!, longitude:lon!)
            let annotation = Annotation(title: children.name!, subtitle: children.street! + " " + children.houseNumber!, id: children.id!, coordinate: coordinates)
            DispatchQueue.main.async {
                self.mapWindow.addAnnotation(annotation)
            }
        }
        print("Added annotations")
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if #available(iOS 11.0, *) {
            guard let annotation = annotation as? Annotation else { return nil }
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                dequeuedView.markerTintColor = UIColor(red: 1, green: 0.3529, blue: 0.302, alpha: 1.0)
                if app!.favorites.keys.contains(annotation.id!) {
                    print("Match")
                    dequeuedView.markerTintColor = UIColor(red: 0.8314, green: 0.6863, blue: 0.2157, alpha: 1.0)
                }
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.markerTintColor = UIColor(red: 1, green: 0.3529, blue: 0.302, alpha: 1.0)
                if app!.favorites.keys.contains(annotation.id!) {
                    print("Match")
                    view.markerTintColor = UIColor(red: 0.8314, green: 0.6863, blue: 0.2157, alpha: 1.0)
                }
            }
            return view
        } else {
            //På tidligere versoner
            return nil
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            var station: Station?
            for i in 0..<filteredStations!.count{
                if filteredStations![i].id == self.id {
                    station = filteredStations![i]
                    break
                }
            }
            if let nextViewController = segue.destination as? Details{
                nextViewController.station = station
                nextViewController.app = app
            }
        } else {
            if let nextViewController = segue.destination as? Profile{
                nextViewController.app = app
            }
            if let nextViewController = segue.destination as? Favorites{
                nextViewController.app = app
            }
        }
    }
    
    @IBAction func detailsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    
    @IBAction func toProfile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    
    @IBAction func toFavorites(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toFavorites", sender: self)
    }
    
    
}





