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
import NotificationBannerSwift
import BLTNBoard

class Home: UIViewController{

    var app: App!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var isInitial: Bool = true
    var id: Int?
    var stations:[Station] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredStations: [Station] = []
    var filteredStationsSearch: [Station] = []
    var connectorDescription: [ConnectorDescription] = []
    var selectedStationSearch: Station?
    var station: Station?
    var isFavorite: Bool?

    var connectors: [Connector] = []
    
    var height: CGFloat = 0.0
    var startPosition: Bool = true
    
    var willDeselectMarker: Bool = true
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = cardStandard()
        return BLTNItemManager(rootItem: rootItem)
    }()


    @IBOutlet weak var tableViewStack: UIStackView!
    @IBOutlet weak var tableViewStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var mapWindow: MKMapView!

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailsStack: UIStackView!
        @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var greyDraggingIndicator: UIView!
    @IBOutlet weak var centerMapButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        
        filteredStations = app.filteredStations
        connectorDescription = app.connectorDescription
        
        loadDetailsElement()
        loadMapElement()
        loadSearchElement()
        
        print(app.stations.count)
        if app.user!.tutorial {
            bulletinManager.showBulletin(above: self)
        }
        


        /*
        if app!.filteredStations.count > 0 {
            filteredStations = app!.filteredStations
        } else {
            app!.updateConnectorForUserInDatabase(connectors: app!.user!.connector!, willFilterStations: true)
            filteredStations = app!.filteredStations
        }
         */
 
    }
    
    override func didReceiveMemoryWarning() {
        print("memory")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredStations = app.filteredStations
        searchController.searchBar.sizeToFit()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapElement.handleTapOnMap(_:)))
        mapWindow.addGestureRecognizer(gestureRecognizer)
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
        if sender.state == UIGestureRecognizer.State.began {
            height = contentViewHeightConstraint.constant
        }
        
        contentViewHeightConstraint.constant = -(gesture.y - height)
        
        if contentViewHeightConstraint.constant < UIScreen.main.bounds.height * 0.6 {
            blurView.alpha = (contentViewHeightConstraint.constant/UIScreen.main.bounds.height * 0.45)
        }

        if sender.state == UIGestureRecognizer.State.ended {
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
    
    func cardStandard() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Stasjon")
        page.image = UIImage(named: "Card-standard")
        page.descriptionText = "Blå markører viser hvor det er plassert en stasjon som er kompatibel med din bil"
        page.appearance.descriptionFontSize = 14.0
        page.actionButtonTitle = "Neste"
        page.appearance.actionButtonColor = UIColor.appTheme()
        page.requiresCloseButton = false
        page.isDismissable = false
        page.next = cardRealtime()
        page.actionHandler = { (item: BLTNActionItem) in
                item.manager?.displayNextItem()
            }
        return page
    }
    
    func cardRealtime() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Sanntid")
        page.image = UIImage(named: "Card-realtime")
        page.descriptionText = "Rød markør betyr at stasjonen tilbyr sanntidsinfromasjon. Du vil da kunne se statusen på kontaktene til stasjonen"
        page.appearance.descriptionFontSize = 14.0
        page.actionButtonTitle = "Neste"
        page.appearance.actionButtonColor = UIColor.appTheme()
        page.requiresCloseButton = false
        page.isDismissable = false
        page.next = iconCard()
        page.actionHandler = { (item: BLTNActionItem) in
            item.manager?.displayNextItem()
        }
        return page
    }
    
    func iconCard() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Ikoner")
        page.image = UIImage(named: "Card-fastcharge")
        page.descriptionText = "Dersom en markør viser dette symbolet så tilbyr denne stasjonen hurtiglading"
        page.actionButtonTitle = "Neste"
        page.appearance.actionButtonColor = UIColor.appTheme()
        page.appearance.descriptionFontSize = 14.0
        page.requiresCloseButton = false
        page.isDismissable = false
        page.next = locationCard()
        page.actionHandler = { (item: BLTNActionItem) in
            item.manager?.displayNextItem()
        }
        return page
    }
    
    func locationCard() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Lokasjon")
        page.image = UIImage(named: "Card-location")
        page.descriptionText = "Appen er avhenging av å vite lokasjonen din for å gi den beste brukeropplevelsen, vi lagrer ikke posisjonsdataen din"
        page.actionButtonTitle = "Tillat"
        page.appearance.actionButtonColor = UIColor.appTheme()
        page.appearance.descriptionFontSize = 14.0
        page.requiresCloseButton = false
        page.isDismissable = false
        page.next = pushNotificationsCard()
        page.actionHandler = { (item: BLTNActionItem) in
            self.locationManager.requestWhenInUseAuthorization()
            item.manager?.displayNextItem()
        }
        return page
    }
    
    func pushNotificationsCard() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Push notifikasjoner")
        page.image = UIImage(named: "Card-push-notifications")
        page.descriptionText = "Denne appen lar deg følge en stasjon, du vil da få en push notifikasjon dersom det er få ledige kontakter igjen."
        page.actionButtonTitle = "Tillat"
        page.appearance.actionButtonColor = UIColor.appTheme()
        page.appearance.descriptionFontSize = 14.0
        page.requiresCloseButton = false
        page.isDismissable = false
        page.next = setupConfiguredCard()
        page.actionHandler = { (item: BLTNActionItem) in
            item.manager?.displayNextItem()
        }
        return page
    }
    
    func setupConfiguredCard() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Ferdig!")
        page.image = UIImage(named: "Card-success")
        page.descriptionText = "Da er alt satt opp"
        page.actionButtonTitle = "Ferdig"
        page.appearance.actionButtonColor = UIColor.appTheme()
        page.appearance.descriptionFontSize = 14.0
        page.requiresCloseButton = false
        page.isDismissable = false
        page.actionHandler = { (item: BLTNActionItem) in
            self.app.user?.tutorial = false
            self.app.setUserInDatabase(user: self.app.user!, done: { error in
                if error != nil {
                    let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                    banner.duration = 2
                    banner.show()
                } else {
                    item.manager?.dismissBulletin(animated: true)
                }
            })
        }
        return page
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
            flowLayout.estimatedItemSize = self.view.bounds.size;
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.contentView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

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

            cell.connectorDescription = connectorDescription
            cell.delegate = self as CollectionViewCellDelegate
            cell.realtime = station!.realtimeInfo
            cell.nameLabel.text = station?.name
            if station!.houseNumber != "" {
                cell.streetLabel.text = station!.street + " " + station!.houseNumber + ", " + station!.city
            } else {
                cell.streetLabel.text = station!.street + ", " + station!.city
            }
            
            if station!.parkingFee {
                cell.parkingFeeLabel.text = "Parkerings avgift"
            } else {
                cell.parkingFeeLabel.text = "Gratis parkering"
            }
            
            if app.user!.favorites.keys.contains(station!.id.description){
                cell.favoriteButton.setTitle("Fjern fra favoritter", for: .normal)
                cell.favoriteButton.layer.backgroundColor = UIColor.appleOrange().cgColor
                isFavorite = true
            } else {
                cell.favoriteButton.setTitle("Legg til favoritter", for: .normal)
                cell.favoriteButton.layer.backgroundColor = UIColor.appleGreen().cgColor
                isFavorite = false
            }
            
            //if app!.subscriptions[app!.getStationIdAsString(stationId: station!.id)] != nil {
            if app.isStationSubscribedTo(stationId: station!.id){
                //Bruker følger denne stasjonen skal få presentert teksten "Slutte å følge"
                cell.subscribeButton.setTitle("Slutte å følge", for: .normal)
                cell.subscribeButton.layer.backgroundColor = UIColor.appleYellow().cgColor
            } else {
                //Bruker følger ikke denne stasjonen skal få presentert teksten "Følg"
                cell.subscribeButton.setTitle("Følg", for: .normal)
            }
            
            cell.userComment = station?.userComment
            cell.descriptionLabel.text = station?.descriptionOfLocation
            cell.connectors = app.sortConnectors(station: station!).conn
            cell.userCompatibleConntacts = app.user!.connector
            if station!.realtimeInfo{
                cell.animateRealtime()
                let compatibleConntacts: [Int] = app.findAvailableContacts(station: station!)
                cell.realtimeConnectorCounterLabel.text = compatibleConntacts[0].description + "/" + compatibleConntacts[2].description
                cell.connectorCollectionView.reloadData()
                cell.realtimeLabel.text = "Leverer sanntids informasjon"
                cell.subscribeButton.isEnabled = true
                cell.subscribeButton.layer.backgroundColor = UIColor.pictonBlue().cgColor
            } else {
                cell.realtimeLabel.text = "Leverer ikke sanntids informasjon"
                cell.subscribeButton.isEnabled = false
                cell.subscribeButton.layer.backgroundColor = UIColor.pictonBlueDisabled().cgColor
                cell.realtimeConnectorCounterLabel.text = ""
                cell.killAllAnimations()
            }
            
            app.getImageForStation(station: station!, user: app.user!, done: { image in
                cell.setImage(image: image)
            })
            if locationManager.location != nil {
                let distance = app!.findDistanceToStation(station: station!, location: locationManager.location!)
                if distance < 1000.0 {
                    cell.distanceLabel.text = String(format: "%.0f", distance) + " m"
                } else {
                    cell.distanceLabel.text = String(format: "%.1f", distance/1000) + " km"
                }
            } else {
                cell.distanceLabel.text = ""
            }
            cell.connectorCollectionView.reloadData()
            cell.commentsView.reloadData()
            
            return cell
            
        }
        let cell: TopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath as IndexPath) as! TopCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*
        if indexPath.row == 0 {
            return CGSize(width: self.view.bounds.size.width, height: 94.0)
        } else {
            return CGSize(width: self.view.bounds.size.width, height: (UIScreen.main.bounds.height - 94))
            //Må ta teksten i station?.descriptionofLocation og regne ut hvor stor den blir mtp høyden når fonten er en spesiell størelse.
            //Deretter må jeg finne høyden.
        }
        */
        return CGSize(width: self.view.bounds.size.width, height: UIScreen.main.bounds.height * 0.15)
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
        if let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InfoCell{
            infoCell.killAllAnimations()
        }
        contentView.isHidden = true
    }
    

}

private typealias MapElement = Home
extension MapElement: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func loadMapElement(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapWindow.showsUserLocation = true
        mapWindow.delegate = self
        isInitial = true
        centerMapButton.layer.cornerRadius = 10
        centerMapButton.addShadow()
        self.addAnnotationsToMap()
        mapWindow.userLocation.title = "Min lokasjon"
        
        
    }
    
    func addAnnotationsToMap(){
        self.mapWindow.removeAnnotations(self.mapWindow.annotations)
        print("Adding markers")

        DispatchQueue.global().async {
            for children in self.filteredStations{
                var position = children.position
                position = position.replacingOccurrences(of: "(", with: "")
                position = position.replacingOccurrences(of: ")", with: "")
                let positionArray = position.components(separatedBy: ",")
                let lat = Double(positionArray[0])
                let lon = Double(positionArray[1])
                let coordinates = CLLocationCoordinate2D(latitude:lat!, longitude:lon!)
                var hasFastcharge = false
                for conn in children.conn {
                    if conn.chargerMode > 3 {
                        hasFastcharge = true
                    }
                }
                let annotation = Annotation(title: children.name, subtitle: children.street + " " + children.houseNumber, id: children.id, coordinate: coordinates, realtime: children.realtimeInfo, fastcharge: hasFastcharge)
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
                dequeuedView.markerTintColor = UIColor.pictonBlue()
                
                if annotation.realtime! {
                    dequeuedView.markerTintColor = UIColor.markerRed()
                }
                if app.user!.favorites.keys.contains(annotation.id!.description) {
                    dequeuedView.markerTintColor = UIColor.fruitSalad()
                }
                
                if annotation.fastcharge! {
                    dequeuedView.glyphImage = UIImage(named: "Fastcharge")
                } else {
                  dequeuedView.glyphImage = UIImage(named: "Station")
                }
                
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.markerTintColor = UIColor.pictonBlue()
                
                if annotation.realtime! {
                    view.markerTintColor = UIColor.markerRed()
                }
                if app.user!.favorites.keys.contains(annotation.id!.description) {
                    view.markerTintColor = UIColor.fruitSalad()
                }
                
                if annotation.fastcharge! {
                    view.glyphImage = UIImage(named: "Fastcharge")
                } else {
                    view.glyphImage = UIImage(named: "Station")
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
            

            
            for filteredStation in filteredStations{
                if filteredStation.id == id {
                    station = filteredStation
                    break
                }
            }
            

            listenOnStation()
            
            if app.user!.favorites.keys.contains(station!.id.description){
                isFavorite = true
            } else {
                isFavorite = false
            }
            if let infoCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InfoCell {
                infoCell.setActiveViewFor(element: .InfoElement)
            }
            connectors = app.sortConnectors(station: station!).conn
            collectionView.reloadData()
            
        } else {
            return
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if (view.annotation as? Annotation) != nil {
            if willDeselectMarker {
                detailsDismissedPosition()
                detachListenerOnStation()
                UIView.animate(withDuration: 0.5, animations: {
                    self.blurView.alpha = 0.0
                })
            }
        }
    }
    
    @objc func handleTapOnMap(_ sender: UITapGestureRecognizer) {
        if searchController.isActive == true && tableViewStack.isHidden == true {
            searchController.isActive = false
        }
    }

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if isInitial == true {
            let regionRadius = CLLocationDistance(1500)
            let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            isInitial = false
        } else {
            return
        }
    }

    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if !willDeselectMarker {
            for annotation in views {
                if let anno = annotation.annotation as? Annotation {
                    if anno.id == station!.id {
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
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.appThemeDark()
        textFieldInsideSearchBar?.textColor = UIColor.white
        searchController.searchBar.setValue("Avbryt", forKey:"_cancelButtonText")
        
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
            filteredStationsSearch = filteredStations.filter { filteredStations in
                return (filteredStations.name.lowercased().contains(searchText.lowercased()))
            }
            if locationManager.location != nil {
                filteredStationsSearch.sort(by: { (this: Station, that: Station) -> Bool in
                    return app!.findDistanceToStation(station: this, location: locationManager.location!) < app!.findDistanceToStation(station: that, location: locationManager.location!)
                })
            }
            
        } else {
            tableViewStack.isHidden = true
            filteredStationsSearch = app.filteredStations
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStationsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.nameLabel?.text = filteredStationsSearch[indexPath.row].name
        cell.adressLabel?.text = filteredStationsSearch[indexPath.row].city + " " + filteredStationsSearch[indexPath.row].street + " " + filteredStationsSearch[indexPath.row].houseNumber
        if locationManager.location == nil {
            cell.distanceLabel.text = ""
        } else {
            let distance = app!.findDistanceToStation(station: filteredStationsSearch[indexPath.row], location: locationManager.location!)
            if distance < 1000.0 {
                cell.distanceLabel.text = String(format: "%.0f", distance) + " m"
            } else {
                cell.distanceLabel.text = String(format: "%.1f", distance/1000) + " km"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveMapToMarker(selectedStation: filteredStationsSearch[indexPath.row])
    }
    
    func moveMapToMarker(selectedStation: Station){
        id = selectedStation.id
        station = selectedStation
        listenOnStation()
        
        if app.user!.favorites.keys.contains(station!.id.description){
            isFavorite = true
        } else {
            isFavorite = false
        }
        if let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InfoCell {
            infoCell.setActiveViewFor(element: .InfoElement)
        }
        connectors = app.sortConnectors(station: station!).conn
        collectionView.reloadData()
        tableViewStack.isHidden = true
        //Move map to correct position
        var position = station!.position
        position = position.replacingOccurrences(of: "(", with: "")
        position = position.replacingOccurrences(of: ")", with: "")
        let positionArray = position.components(separatedBy: ",")
        let lat = Double(positionArray[0])! - 0.007
        let lon = Double(positionArray[1])
        let coordinates = CLLocationCoordinate2D(latitude:lat, longitude:lon!)
        
        let regionRadius = CLLocationDistance(1500)
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapWindow.setRegion(coordinateRegion, animated: true)
        
        //mapWindow.setCenter(coordinates, animated: true)
        
        if startPosition {
            detailsStartPosition(withAnimation: false)
            self.view.layoutIfNeeded()
            detailsEngagedPosition(blur: 0.26)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        for anno in mapWindow.annotations{
            if anno is Annotation {
                let annotation = anno as! Annotation
                if annotation.id == id! {
                    mapWindow.selectAnnotation(anno, animated: true)
                }
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
                app.user?.favorites.removeValue(forKey: station!.id.description)
                app.setUserInDatabase(user: app.user!, done: { error in
                    if error != nil {
                        // Error
                        let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                        banner.duration = 2
                        banner.show()
                    } else {
                        let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                        infoCell.favoriteButton.setTitle("Legg til favoritter", for: .normal)
                        infoCell.favoriteButton.layer.backgroundColor = UIColor.appleGreen().cgColor
                        self.isFavorite = false
                        let banner = StatusBarNotificationBanner(title: "Fjernet fra favoritter", style: .success)
                        banner.duration = 2
                        banner.show()
                        self.willDeselectMarker = false
                        self.addAnnotationsToMap()
                    }
                })
            } else {
                app.user?.favorites.updateValue(Date().getTimestamp(), forKey: station!.id.description)
                app.setUserInDatabase(user: app.user!, done: { error in
                    if error != nil {
                        // Error
                        let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                        banner.duration = 2
                        banner.show()
                    } else {
                        let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                        infoCell.favoriteButton.setTitle("Fjern fra favoritter", for: .normal)
                        infoCell.favoriteButton.layer.backgroundColor = UIColor.appleOrange().cgColor
                        self.isFavorite = true
                        let banner = StatusBarNotificationBanner(title: "Lagt til favoritter", style: .success)
                        banner.duration = 2
                        banner.show()
                        self.willDeselectMarker = false
                        self.addAnnotationsToMap()
                    }
                })
            }

            
            
        case .subscribe:
            //if app!.subscriptions[app!.getStationIdAsString(stationId: station!.id)] != nil {
            if app.isStationSubscribedTo(stationId: station!.id){
                let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                app.unsubscribeToStation(station: station!, done: { error in
                    if error != nil {
                        //Error
                        let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                        banner.duration = 2
                        banner.show()
                    } else {
                        infoCell.subscribeButton.setTitle("Følg", for: .normal)
                        infoCell.subscribeButton.layer.backgroundColor = UIColor.pictonBlue().cgColor
                        let banner = StatusBarNotificationBanner(title: "Du følger ikke lenger denne stasjonen", style: .warning)
                        banner.duration = 2
                        banner.show()
                    }
                    
                })
            } else {
                let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                app.subscribeToStation(station: station!, done: { error in
                    if error != nil {
                        //Error
                        let banner = StatusBarNotificationBanner(title: "Noe gikk galt", style: .danger)
                        banner.duration = 2
                        banner.show()
                    } else {
                        infoCell.subscribeButton.setTitle("Slutt å følg", for: .normal)
                        infoCell.subscribeButton.layer.backgroundColor = UIColor.appleYellow().cgColor
                        let banner = StatusBarNotificationBanner(title: "Du følger nå denne stasjonen", style: .warning)
                        banner.duration = 2
                        banner.show()
                    }
                })
            }
        }
    }
}

private typealias Service = Home
extension Service {
    func listenOnStation(){
        app.listenOnStation(stationId: station!.id, done: { station in
            print("Listening")
            self.station = station
            self.connectors = self.app.sortConnectors(station: station).conn
            
            
            DispatchQueue.main.async {
                
                var availableConntacts: Int = 0
                
                for conn in station.conn {
                    if conn.error == 0 && conn.isTaken == 0 && self.app.checkIfConntactIsAppliable(connector: conn) {
                        availableConntacts += 1
                    }
                }
                
                let compatibleConntacts: [Int] = self.app.findAvailableContacts(station: station)
                //Available/Applicable contacts for station label.
                _ = compatibleConntacts[0].description + "/" + compatibleConntacts[1].description
                
                //self.collectionView.reloadData()
                if self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) != nil {
                    let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                    infoCell.connectors = self.connectors
                    infoCell.realtimeConnectorCounterLabel.text = compatibleConntacts[0].description + "/" + compatibleConntacts[2].description
                    infoCell.connectorCollectionView.reloadData()
                }
            }
        })
    }
    
    func detachListenerOnStation(){
        print("Detatch")
        app.detachListenerOnStation(stationId: station!.id)
    }
}
