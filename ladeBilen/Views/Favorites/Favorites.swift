//
//  favoritesViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Disk
import NotificationBannerSwift

class Favorites: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var app: App!
    var favoriteArray: [Station] = []
    var realtimeArray: [Int] = []
    var followingArray: [Station] = []
    var station: Station?
    var isDetailsAFavoriteStation: Bool = false
    var height: CGFloat = 0.0
    var startPosition: Bool = true
    var isFavorite: Bool?
    var connectors: [Connector]?
    var countCompatible: Int?
    var connectorDescription: [ConnectorDescription]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailsStack: UIStackView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var greyDraggingIndicator: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellWithReuseIdentifier: "FavoritesCell")
        collectionView.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "LabelCell")
        collectionView.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCell")
        connectorDescription = app.connectorDescription
        loadDetailsElement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.followingArray = []
        self.favoriteArray = []
        if app.subscriptions.count == 0 {
            app.getSubscriptionsFromDatabase {
                for sub in self.app.subscriptions{
                    let id = self.app.getStationIdFromString(stationId: sub.id)
                    for station in self.app.stations{
                        if station.id == id{
                            self.followingArray.append(station)
                        }
                    }
                }
                self.collectionView.reloadData()
            }
        } else {
            for sub in self.app.subscriptions{
                let id = self.app.getStationIdFromString(stationId: sub.id)
                for station in self.app.stations{
                    if station.id == id{
                        self.followingArray.append(station)
                    }
                }
            }
        }
        
        for station in app.stations{
            if app.user!.favorites.keys.contains(station.id.description) {
                self.favoriteArray.append(station)
                self.realtimeArray.append(station.id)
                print("Setting up listener on: " + station.id.description)
                listenOnStation(station: station, done: { updatedStation in
                    if updatedStation.id == self.station?.id{
                        print("Matching stations")
                        self.station = updatedStation
                        for i in 0 ..< self.favoriteArray.count {
                            if self.favoriteArray[i].id == updatedStation.id {
                                self.favoriteArray[i] = updatedStation
                            }
                        }
                        self.connectors = self.app.sortConnectors(station: updatedStation).conn
                        let compatibleConntacts: [Int] = self.app.findAvailableContacts(station: updatedStation)
                        let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                        infoCell.connectors = self.connectors
                        infoCell.compatibleConntacts = compatibleConntacts[0]
                        infoCell.realtimeConnectorCounterLabel.text = compatibleConntacts[0].description + "/" + compatibleConntacts[1].description
                        infoCell.connectorCollectionView.reloadData()
                    }
                    for i in 0..<self.favoriteArray.count {
                        if self.favoriteArray[i].id == updatedStation.id {
                            self.favoriteArray[i] = updatedStation
                            self.collectionView.reloadData()
                            break
                        }
                    }
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for station in realtimeArray {
            print("Removed listener on station: " + station.description)
            detachListenerOnStation(stationId: station)
        }
    }
    
    @IBAction func contentViewIsTapped(_ sender: UITapGestureRecognizer) {
        detailsEngagedPosition(blur: 0.26)
        height = contentViewHeightConstraint.constant
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
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
    
    
    func populateFavoritesArray(){
        //Needs refactoring, not nessecary to itterate all stations
        self.followingArray = []
        if app.subscriptions.count == 0 {
            app.getSubscriptionsFromDatabase {
                for sub in self.app.subscriptions{
                    let id = self.app.getStationIdFromString(stationId: sub.id)
                    for station in self.app.stations{
                        if station.id == id{
                            self.followingArray.append(station)
                        }
                    }
                }
                self.collectionView.reloadData()
            }
        } else {
            for sub in self.app.subscriptions{
                let id = self.app.getStationIdFromString(stationId: sub.id)
                for station in self.app.stations{
                    if station.id == id{
                        self.followingArray.append(station)
                    }
                }
            }
        }
        self.favoriteArray = []
        print("Refreshing collectionviews")
        for station in app.stations{
            if app.user!.favorites.keys.contains(station.id.description) {
                self.favoriteArray.append(station)
            }
        }
        collectionView.reloadData()
    }
    
    func addShadowFavoritesCell(cell: FavoritesCell) -> FavoritesCell{
        //cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    func addShadowSubscriptionCell(cell: SubscriptionCell) -> SubscriptionCell{
        //cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
}

private typealias DetailsElement = Favorites
extension DetailsElement {
    func loadDetailsElement(){
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        
        self.detailsCollectionView.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "ImageCellIdentifier")
        self.detailsCollectionView.register(UINib(nibName: "InfoCell", bundle: nil), forCellWithReuseIdentifier: "InfoCellIdentifier")
        if let flowLayout = detailsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 95)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.contentView.isHidden = true
        
        greyDraggingIndicator.layer.cornerRadius = 2
        blurView.alpha = 0.0
        contentView.layer.cornerRadius = 20
        contentView.addShadow()
        
        detailsDismissedPosition()
    }
    
    func detailsStartPosition(withAnimation: Bool){
        
        
        contentViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.15
        print(UIScreen.main.bounds.height * 0.15)
        height = contentViewHeightConstraint.constant
        contentView.isHidden = false
        
        detailsCollectionView.isScrollEnabled = false
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
        
        detailsCollectionView.isScrollEnabled = false
        startPosition = false
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = blur
        })
    }
    
    func detailsDismissedPosition(){
        detailsStartPosition(withAnimation: true)
        if let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? InfoCell{
            infoCell.killAllAnimations()
        }
        
        contentView.isHidden = true
    }
}

private typealias CollectionViewLayoutMethods = Favorites
extension CollectionViewLayoutMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailsCollectionView {
            return 1
        } else {
            if followingArray.count != 0{
                return favoriteArray.count + followingArray.count + 2
            } else {
                return favoriteArray.count + 2
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailsCollectionView {
            if station != nil {
                print("Building details collectionview")
                
                let cell: InfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCellIdentifier", for: indexPath as IndexPath) as! InfoCell
                cell.connectorCollectionView.reloadData()
                cell.commentsView.reloadData()
                cell.connectorDescription = connectorDescription
                cell.delegate = self as CollectionViewCellDelegate
                cell.realtime = station!.realtimeInfo
                cell.nameLabel.text = station?.name
                cell.compatibleConntacts = countCompatible
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
                cell.connectors = self.app.sortConnectors(station: station!).conn
                if station!.realtimeInfo{
                    cell.animateRealtime()
                    let compatibleConntacts: [Int] = self.app.findAvailableContacts(station: station!)
                    cell.compatibleConntacts = compatibleConntacts[0]
                    cell.realtimeConnectorCounterLabel.text = compatibleConntacts[0].description + "/" + compatibleConntacts[1].description
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
                return cell
            }
            let cell: TopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath as IndexPath) as! TopCell
            return cell
        } else {
            if indexPath.row == 0{
                //Følger label cell
                let cell: LabelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath as IndexPath) as! LabelCell
                cell.label.text = "Følger"
                return cell
            } else if indexPath.row == followingArray.count + 1{
                //Favoritter label cell
                let cell: LabelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath as IndexPath) as! LabelCell
                cell.label.text = "Favoritter"
                return cell
            } else if indexPath.row <= followingArray.count{
                //subscription cell
                let row = indexPath.row - 1
                var cell: SubscriptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath as IndexPath) as! SubscriptionCell
                cell.delegate = self as CollectionViewCellDelegate
                cell.stationNameLabel.text = followingArray[row].name
                cell = addShadowSubscriptionCell(cell: cell)
                print(followingArray[row].id)
//              Må fikse denne, ikke sikkert at following array eksisterer
                //cell.timeTo = (app!.subscriptions[app!.getStationIdAsString(stationId: followingArray[row].id)]?["to"])!
                cell.timeTo = app.findSubscription(stationId: followingArray[row].id)!.to
                cell.updateTimer()
                return cell
            }  else {
                //Favoritter cell
                let row = indexPath.row - (followingArray.count + 2)
                var cell: FavoritesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath as IndexPath) as! FavoritesCell
                cell.activityLabel.text = "-Høy-"
                cell.subscriberAmountLabel.text = "-20-"
                cell.stationNameLabel.text = favoriteArray[row].name
                cell.stationStreetLabel.text = favoriteArray[row].street + " " + favoriteArray[row].houseNumber
                cell.stationCityLabel.text = favoriteArray[row].city
                var availableConnectors = app.findAvailableContacts(station: favoriteArray[row])
                cell.isRealtime(realtime: favoriteArray[row].realtimeInfo)
                if favoriteArray[row].realtimeInfo {
                    cell.availableConntactsLabelMessage.text = "Kontakter"
                    cell.availableContactsLabel.text = availableConnectors[0].description + "/" + availableConnectors[1].description
                } else {
                    cell.availableConntactsLabelMessage.text = ""
                    cell.availableContactsLabel.text = ""
                }
                cell.station = favoriteArray[row]
                cell = addShadowFavoritesCell(cell: cell)
                cell.isAvailableLabel.text = "-Mangler-"
                return cell
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == detailsCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: self.view.bounds.size.width, height: 94.0)
            } else {
                return CGSize(width: self.view.bounds.size.width, height: (UIScreen.main.bounds.height - 94))
                //Må ta teksten i station?.descriptionofLocation og regne ut hvor stor den blir mtp høyden når fonten er en spesiell størelse.
                //Deretter må jeg finne høyden.
            }
        } else {
            var height = self.view.frame.size.width * 0.35
            let width  = self.view.frame.size.width * 0.9
            if indexPath.row == 0{
                height = 25
            } else if indexPath.row == followingArray.count + 1{
                height = 25
            } else if indexPath.row <= followingArray.count {
                height = 39
            } else {
                if favoriteArray[indexPath.row - (2 + followingArray.count)].realtimeInfo {
                    height = self.view.frame.size.width * 0.35
                } else {
                    height = self.view.frame.size.width * 0.20
                }
            }
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if indexPath.row >= followingArray.count + 2 {
                isDetailsAFavoriteStation = true
                print("selected 1")
                let row = indexPath.row - (followingArray.count + 2)
                station = favoriteArray[row]
                self.connectors = self.app.sortConnectors(station: station!).conn
                detailsStartPosition(withAnimation: true)
                detailsCollectionView.reloadData()
                
            } else if indexPath.row != 0 && indexPath.row <= followingArray.count{
                isDetailsAFavoriteStation = false
                print("selected 2")
                let row = indexPath.row - 1
                station = followingArray[row]
                self.connectors = self.app.sortConnectors(station: station!).conn
                detailsStartPosition(withAnimation: true)
                detailsCollectionView.reloadData()
                listenOnStation(station: station!, done: { uStation in
                    if uStation.id == self.station?.id{
                        print("Matching stations")
                        let updatedStation = uStation
                        self.connectors = self.app.sortConnectors(station: updatedStation).conn
                        let compatibleConntacts: [Int] = self.app.findAvailableContacts(station: updatedStation)
                        DispatchQueue.main.async {
                            let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                            infoCell.connectors = self.connectors
                            infoCell.compatibleConntacts = compatibleConntacts[0]
                            infoCell.realtimeConnectorCounterLabel.text = compatibleConntacts[0].description + "/" + compatibleConntacts[1].description
                            infoCell.connectorCollectionView.reloadData()
                        }
                    }
                })
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 && indexPath.row <= followingArray.count{
            self.detachListenerOnStation(stationId: self.followingArray[indexPath.row - 1].id)
        }
    }
}

private typealias Delegate = Favorites
extension Delegate: CollectionViewCellDelegate {
    
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton, action: action, skipConfirmation: Bool) {
        if action == .unsubscribe {
            if !skipConfirmation {
                let alert = UIAlertController(title: "Slutte å følge?", message: "Du vil ikke lenger få oppdateringer angående denne stasjonen.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: { action in
                    print("Unsubbing")
                    var indexPath = self.collectionView.indexPath(for: cell)
                    self.app.unsubscribeToStation(station: self.followingArray[indexPath!.row - 1], done: {_ in
                        self.populateFavoritesArray()
                        self.detailsCollectionView.reloadData()
                        let banner = StatusBarNotificationBanner(title: "Du følger ikke lenger denne stasjonen", style: .warning)
                        banner.show()
                    })
                }))
                alert.addAction(UIAlertAction(title: "Nei", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                var indexPath = self.collectionView.indexPath(for: cell)
                self.app.unsubscribeToStation(station: self.followingArray[indexPath!.row - 1], done: {_ in
                    self.populateFavoritesArray()
                    self.detailsCollectionView.reloadData()
                })
            }
        }
        else if action == .cancel {
            if startPosition {
                detailsDismissedPosition()
                if !isDetailsAFavoriteStation {
                    detachListenerOnStation(stationId: station!.id)
                }
            } else {
                detailsStartPosition(withAnimation: true)
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        } else if action == .favorite {
            if isFavorite! {
                app.user?.favorites.removeValue(forKey: station!.id.description)
                app.setUserInDatabase(user: app.user!, done: { code in
                    let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                    infoCell.favoriteButton.setTitle("Legg til favoritter", for: .normal)
                    infoCell.favoriteButton.layer.backgroundColor = UIColor.appleGreen().cgColor
                    self.isFavorite = false
                    let banner = StatusBarNotificationBanner(title: "Fjernet fra favoritter", style: .success)
                    banner.show()
                    self.populateFavoritesArray()
                })
            } else {
                app.user?.favorites.updateValue(Date().getTimestamp(), forKey: station!.id.description)
                app.setUserInDatabase(user: app.user!, done: { code in
                    let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                    infoCell.favoriteButton.setTitle("Fjern fra favoritter", for: .normal)
                    infoCell.favoriteButton.layer.backgroundColor = UIColor.appleOrange().cgColor
                    self.isFavorite = true
                    let banner = StatusBarNotificationBanner(title: "Lagt til favoritter", style: .success)
                    banner.show()
                    self.populateFavoritesArray()
                })
            }
        } else if action == .subscribe {
            //if app!.subscriptions[app!.getStationIdAsString(stationId: station!.id)] != nil {
            if app.isStationSubscribedTo(stationId: station!.id){
                let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                app.unsubscribeToStation(station: station!, done: { _ in
                    infoCell.subscribeButton.setTitle("Følg", for: .normal)
                    infoCell.subscribeButton.layer.backgroundColor = UIColor.pictonBlue().cgColor
                    let banner = StatusBarNotificationBanner(title: "Du følger ikke lenger denne stasjonen", style: .warning)
                    banner.show()
                    self.populateFavoritesArray()
                })
            } else {
                let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                app.subscribeToStation(station: station!, done: { _ in
                    infoCell.subscribeButton.setTitle("Slutt å følg", for: .normal)
                    infoCell.subscribeButton.layer.backgroundColor = UIColor.appleYellow().cgColor
                    let banner = StatusBarNotificationBanner(title: "Du følger nå denne stasjonen", style: .warning)
                    banner.show()
                    self.populateFavoritesArray()
                })
            }
        }
    }
}

private typealias Service = Favorites
extension Service {
    
    func listenOnStation(station: Station, done: @escaping (_ updatedStation: Station)-> Void){
        app.listenOnStation(stationId: station.id, done: { station in
            print("Update on: " + station.id.description)
            DispatchQueue.main.async {
                done(station)
            }
        })
    }
    
    func detachListenerOnStation(stationId: Int){
        print("Detached listener on: " + stationId.description)
        app.detachListenerOnStation(stationId: stationId)
    }
}
