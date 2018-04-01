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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredStations = app!.filteredStations

        /*
        if app!.filteredStations.count > 0 {
            filteredStations = app!.filteredStations
        } else {
            app!.updateConnectorForUserInDatabase(connectors: app!.user!.connector!, willFilterStations: true)
            filteredStations = app!.filteredStations
        }
 */
 
        mapWindow.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        isInitial = true
        initializeMap()
        initializeButtons()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Søk"
        setupNavigationBar()
        imageViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.3
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredStations = app!.filteredStations
        self.addAnnotationsToMap()
        searchController.searchBar.sizeToFit()
    }

    func setupNavigationBar() {
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchController.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
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
    
    //Søkealgoritmen
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
                if app!.user!.favorites!.keys.contains(annotation.id!.description) {
                    dequeuedView.markerTintColor = UIColor(red: 0.8314, green: 0.6863, blue: 0.2157, alpha: 1.0)
                }
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.markerTintColor = UIColor(red: 1, green: 0.3529, blue: 0.302, alpha: 1.0)
                if app!.user!.favorites!.keys.contains(annotation.id!.description) {
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
            infoView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.infoView.layoutIfNeeded()
            }
        } else {
            return
        }
    }
    

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5) {
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
            for filteredStation in filteredStations!{
                if filteredStation.id == self.id {
                    station = filteredStation
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
    
    @IBAction func infoViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    var height: CGFloat = 0.0
    var startPosition: Bool = true

    @IBAction func contentViewIsDragging(_ sender: UIPanGestureRecognizer) {
        let gesture = sender.translation(in: view)
        self.view.endEditing(true)
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        if sender.state == UIGestureRecognizerState.began {
            print("Began movement")
            height = contentViewHeightConstraint.constant
        }
        imageView.isHidden = false

        
        contentViewHeightConstraint.constant = -(gesture.y - height)
        

        if startPosition {
            if contentViewHeightConstraint.constant > UIScreen.main.bounds.height * 0.4 {
                imageViewBottomConstraint.constant = contentViewHeightConstraint.constant
            } else  {
                imageViewBottomConstraint.constant = -((gesture.y + UIScreen.main.bounds.height * 0.1) * 2)
            }
        } else {
            if contentViewHeightConstraint.constant > UIScreen.main.bounds.height * 0.4 {
                imageViewBottomConstraint.constant = contentViewHeightConstraint.constant
            } else  {
                imageViewBottomConstraint.constant = (-((gesture.y - UIScreen.main.bounds.height * 0.4) * 2)) + navigationBarHeight
            }
        }


        
        
        

        
        
        if sender.state == UIGestureRecognizerState.ended {
            print("Ended movement")
            print(navigationBarHeight)

            
            if contentViewHeightConstraint.constant > UIScreen.main.bounds.height * 0.5 {
                contentViewHeightConstraint.constant = UIScreen.main.bounds.height - imageViewHeightConstraint.constant - navigationBarHeight
                imageViewBottomConstraint.constant = UIScreen.main.bounds.height - imageViewHeightConstraint.constant - navigationBarHeight
                print(UIScreen.main.bounds.height)
                print(UIScreen.main.bounds.height - imageViewHeightConstraint.constant - navigationBarHeight)
                height = contentViewHeightConstraint.constant
                startPosition = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                contentViewHeightConstraint.constant = 70
                height = contentViewHeightConstraint.constant

                startPosition = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
        
        
    }
}




