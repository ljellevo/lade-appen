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

class Home: UIViewController{

    var app: App?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var isInitial: Bool = true
    var id: Int?
    var stations:[Station] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredStations: [Station]?
    var connectorDescription: [Int:String]?
    var selectedStationSearch: Station?
    var station: Station?
    var isFavorite: Bool?

    var countCompatible: Int?
    var connectors: [Connector]?
    
    var height: CGFloat = 0.0
    var startPosition: Bool = true
    
    var willDeselectMarker: Bool = true


    @IBOutlet weak var tableViewStack: UIStackView!
    @IBOutlet weak var tableViewStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var mapWindow: MKMapView!
    @IBOutlet weak var nearestButton: UIButton!
    @IBOutlet weak var buttonStackConstraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var buttonStackConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailsStack: UIStackView!
        @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var greyDraggingIndicator: UIView!
    @IBOutlet weak var centerMapButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredStations = app!.filteredStations
        connectorDescription = app!.connectorDescription
        
        loadDetailsElement()
        loadMapElement()
        loadSearchElement()
        
        print(app!.stations.count)
        


        /*
        if app!.filteredStations.count > 0 {
            filteredStations = app!.filteredStations
        } else {
            app!.updateConnectorForUserInDatabase(connectors: app!.user!.connector!, willFilterStations: true)
            filteredStations = app!.filteredStations
        }
         */
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredStations = app!.filteredStations
        self.addAnnotationsToMap()
        searchController.searchBar.sizeToFit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // The following line makes cells size properly in iOS 12.
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? Profile{
            nextViewController.app = app
        }
        if let nextViewController = segue.destination as? Favorites{
            nextViewController.app = app
        }
    }
    
    @IBAction func toProfile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    @IBAction func toFavorites(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toFavorites", sender: self)
    }
    
    @IBAction func detailsViewWasTapped(_ sender: UITapGestureRecognizer) {
        detailsEngagedPosition(blur: 0.26)
        height = contentViewHeightConstraint.constant
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func centerMapOnUserLocation(_ sender: UIButton) {
        mapWindow.setCenter((locationManager.location?.coordinate)!, animated: true)
    }
    
    @IBAction func contentViewIsDragging(_ sender: UIPanGestureRecognizer) {
        let gesture = sender.translation(in: view)
        let velocity = sender.velocity(in: self.view).y

        self.view.endEditing(true)
        if sender.state == UIGestureRecognizerState.began {
            height = contentViewHeightConstraint.constant
        }
        
        contentViewHeightConstraint.constant = -(gesture.y - height)
        
        if contentViewHeightConstraint.constant < UIScreen.main.bounds.height * 0.6 {
            blurView.alpha = (contentViewHeightConstraint.constant/UIScreen.main.bounds.height * 0.45)
        }

        if sender.state == UIGestureRecognizerState.ended {
            if velocity < -800 {
                detailsEngagedPosition(blur: 0.26)
                UIView.animate(withDuration: TimeInterval(UIScreen.main.bounds.height/velocity), delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                    self.view.layoutIfNeeded()
                })
            } else if velocity > 800 {
                detailsStartPosition(withAnimation: true)
                UIView.animate(withDuration: TimeInterval(UIScreen.main.bounds.height/velocity), delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                    self.view.layoutIfNeeded()
                })
                
            } else {
                if contentViewHeightConstraint.constant > UIScreen.main.bounds.height * 0.25 {
                    detailsEngagedPosition(blur: 0.26)
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                        self.view.layoutIfNeeded()
                    })
                    
                } else {
                    detailsStartPosition(withAnimation: true)
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
            
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
}

private typealias DetailsElement = Home
extension DetailsElement: UICollectionViewDelegate, UICollectionViewDataSource {

    func loadDetailsElement(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "ImageCellIdentifier")
        self.collectionView.register(UINib(nibName: "InfoCell", bundle: nil), forCellWithReuseIdentifier: "InfoCellIdentifier")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.contentView.isHidden = true
        
        greyDraggingIndicator.layer.cornerRadius = 2
        blurView.alpha = 0.0
        contentView.layer.cornerRadius = 20
        contentView.addShadow()
        
        detailsDismissedPosition()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if station != nil {
            print("Details loaded")
            
            let cell: InfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCellIdentifier", for: indexPath as IndexPath) as! InfoCell
            cell.connectorCollectionView.reloadData()
            cell.commentsView.reloadData()
            cell.connectorDescription = connectorDescription
            cell.delegate = self as CollectionViewCellDelegate
            cell.realtime = station!.realtimeInfo
            if station!.realtimeInfo! {
                cell.animateRealtime()
                var availableConnectors = app!.findAvailableContacts(station: station!)
                cell.realtimeConnectorCounterLabel.text = availableConnectors[0].description + "/" + availableConnectors[1].description
            } else {
                cell.realtimeConnectorCounterLabel.text = ""
                cell.killAllAnimations()
            }
            cell.nameLabel.text = station?.name
            cell.compatibleConntacts = countCompatible
            if station!.houseNumber != "" {
                cell.streetLabel.text = station!.street! + " " + station!.houseNumber! + ", " + station!.city!
            } else {
                cell.streetLabel.text = station!.street! + ", " + station!.city!
            }
            
            if station!.realtimeInfo!{
                cell.realtimeLabel.text = "Leverer sanntids informasjon"
            } else {
                cell.realtimeLabel.text = "Leverer ikke sanntids informasjon"
            }
            
            if station!.parkingFee! {
                cell.parkingFeeLabel.text = "Parkerings avgift"
            } else {
                cell.parkingFeeLabel.text = "Gratis parkering"
            }
            
            if isFavorite! {
                cell.favoriteButton.setTitle("Fjern fra favoritter", for: .normal)
                cell.favoriteButton.layer.backgroundColor = UIColor.appleOrange().cgColor
            } else {
                cell.favoriteButton.setTitle("Legg til favoritter", for: .normal)
                cell.favoriteButton.layer.backgroundColor = UIColor.appleGreen().cgColor
            }
            
            cell.userComment = station?.userComment
            cell.descriptionLabel.text = station?.descriptionOfLocation
            cell.connectors = connectors!
            return cell
            
        }
        let cell: TopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath as IndexPath) as! TopCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self.view.bounds.size.width, height: 94.0)
        } else {
            return CGSize(width: self.view.bounds.size.width, height: (UIScreen.main.bounds.height - 94))
            //Må ta teksten i station?.descriptionofLocation og regne ut hvor stor den blir mtp høyden når fonten er en spesiell størelse.
            //Deretter må jeg finne høyden.
        }
    }
    
    
    func detailsStartPosition(withAnimation: Bool){
        contentView.isHidden = false

        contentViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.15
        height = contentViewHeightConstraint.constant

        collectionView.isScrollEnabled = false
        startPosition = true
        if withAnimation {
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 0.0
            })
        } else {
            self.blurView.alpha = 0.0
        }
        
    }
    
    func detailsEngagedPosition(blur: CGFloat){
        contentViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.6
        height = contentViewHeightConstraint.constant

        collectionView.isScrollEnabled = false
        startPosition = false
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = blur
        })
    }
    
    func detailsDismissedPosition(){
        detailsStartPosition(withAnimation: true)
        contentView.isHidden = true
    }
    

}

private typealias MapElement = Home
extension MapElement: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func loadMapElement(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapWindow.showsUserLocation = true
        mapWindow.delegate = self
        isInitial = true
        centerMapButton.layer.cornerRadius = 5
        centerMapButton.addShadow()
        
    }
    
    func addAnnotationsToMap(){
        self.mapWindow.removeAnnotations(self.mapWindow.annotations)

        DispatchQueue.global().async {
            for children in self.filteredStations!{
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
            print("----------Selected, setting up listener----------")
            
            if willDeselectMarker {
                detailsStartPosition(withAnimation: true)
            }
            

            
            for filteredStation in filteredStations!{
                if filteredStation.id == id {
                    station = filteredStation
                    break
                }
            }
            

            listenOnStation()
            
            if app!.user!.favorites!.keys.contains(station!.id!.description){
                isFavorite = true
            } else {
                isFavorite = false
            }
            if let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InfoCell {
                infoCell.setActiveViewFor(element: .InfoElement)
            }
            self.connectors = self.app!.sortConnectors(station: station!).conn
            collectionView.reloadData()
            
        } else {
            return
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if willDeselectMarker {
            detailsDismissedPosition()
            detatchAllListeners()
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 0.0
            })
        }
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

    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if !willDeselectMarker {
            for annotation in views {
                if let anno = annotation.annotation as? Annotation {
                    if anno.id == station!.id! {
                        mapWindow.selectAnnotation(anno, animated: false)
                        willDeselectMarker = true
                        break
                    }
                }
            }
        }
    }
    
}

private typealias SearchElement = Home
extension SearchElement: UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    func loadSearchElement(){
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Søk"
        
        self.definesPresentationContext = true
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchController.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
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
        station = filteredStations![indexPath.row]
        listenOnStation()
        
        if app!.user!.favorites!.keys.contains(station!.id!.description){
            isFavorite = true
        } else {
            isFavorite = false
        }
        if let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InfoCell {
            infoCell.setActiveViewFor(element: .InfoElement)
        }
        self.connectors = self.app!.sortConnectors(station: station!).conn
        collectionView.reloadData()
        tableViewStack.isHidden = true
        //Move map to correct position
        var position = station!.position
        position = position?.replacingOccurrences(of: "(", with: "")
        position = position?.replacingOccurrences(of: ")", with: "")
        let positionArray = position!.components(separatedBy: ",")
        let lat = Double(positionArray[0])! - 0.007
        let lon = Double(positionArray[1])
        let coordinates = CLLocationCoordinate2D(latitude:lat, longitude:lon!)
        mapWindow.setCenter(coordinates, animated: true)
        
        
        if startPosition {
            detailsStartPosition(withAnimation: false)
            self.view.layoutIfNeeded()
            detailsEngagedPosition(blur: 0.26)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        searchController.searchBar.endEditing(true)
    }
}

private typealias Protocols = Home
extension Protocols: CollectionViewCellDelegate  {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton, action: action) {
        switch action {
        case .unsubscribe:
            print("Unsubscibe")
        
        case .cancel:
            if !startPosition {
                detailsStartPosition(withAnimation: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                    self.blurView.alpha = 0.0
                })
            } else {
                self.contentView.isHidden = true
                if (mapWindow.selectedAnnotations.count > 0) {
                    self.mapWindow.deselectAnnotation(mapWindow.selectedAnnotations[0], animated: true)
                }
            }
        case .favorite:
            if isFavorite! {
                app!.user?.favorites?.removeValue(forKey: station!.id!.description)
                app?.setUserInDatabase(user: app!.user!)
                let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                infoCell.favoriteButton.setTitle("Legg til favoritter", for: .normal)
                infoCell.favoriteButton.layer.backgroundColor = UIColor.appleGreen().cgColor
                isFavorite = false
            } else {
                app!.user?.favorites?.updateValue(Date().getTimestamp(), forKey: station!.id!.description)
                app?.setUserInDatabase(user: app!.user!)
                let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                infoCell.favoriteButton.setTitle("Fjern fra favoritter", for: .normal)
                infoCell.favoriteButton.layer.backgroundColor = UIColor.appleOrange().cgColor
                isFavorite = true
            }

            willDeselectMarker = false
            addAnnotationsToMap()
            
        case .subscribe:
            //MARK: Subscribe to station implementation
            print("Subscribe")
            app!.subscribeToStation(station: station!)
        }
    }
}

private typealias Service = Home
extension Service {
    func listenOnStation(){
        app?.listenOnStation(stationId: station!.id!, done: { station in
            print("Listening")
            self.station = station
            self.connectors = self.app!.sortConnectors(station: station).conn
            
            
            DispatchQueue.main.async {
                
                var availableConntacts: Int = 0
                
                for conn in station.conn {
                    if conn.error == 0 && conn.isTaken == 0 && self.app!.checkIfConntactIsAppliable(connector: conn) {
                        availableConntacts += 1
                    }
                }
                
                let compatibleConntacts: [Int] = self.app!.findAvailableContacts(station: station)
                //Available/Applicable contacts for station label.
                _ = compatibleConntacts[0].description + "/" + compatibleConntacts[1].description
                
                //self.collectionView.reloadData()
                let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                infoCell.connectors = self.connectors
                infoCell.compatibleConntacts = compatibleConntacts[0]
                infoCell.realtimeConnectorCounterLabel.text = compatibleConntacts[0].description + "/" + compatibleConntacts[1].description
                infoCell.connectorCollectionView.reloadData()
                
            }
        })
    }
    
    func detatchAllListeners(){
        print("Detatch")
        app?.detachListenerOnStation(stationId: station!.id!)
    }
}
