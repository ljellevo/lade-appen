//
//  favoritesViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 09.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Disk

class Favorites: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var app: App?
    var favoriteArray: [Station] = []
    var followingArray: [Station] = []
    var station: Station?
    var height: CGFloat = 0.0
    var startPosition: Bool = true
    var isFavorite: Bool?
    var connectors: [Connector]?
    var countCompatible: Int?
    var connectorDescription: [Int:String]?

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
        connectorDescription = app!.connectorDescription

        
        loadDetailsElement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateFavoritesArray()
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
    
    func populateFavoritesArray(){
        favoriteArray = []
        followingArray = []
        for station in app!.stations{
            if app!.user!.favorites!.keys.contains(station.id!.description) {
                self.favoriteArray.append(station)
                self.followingArray.append(station)
            }
        }
        collectionView.reloadData()
    }
    
    func addShadowFavoritesCell(cell: FavoritesCell) -> FavoritesCell{
        cell.contentView.layer.cornerRadius = 10
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
        cell.contentView.layer.cornerRadius = 10
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
        contentView.isHidden = false
        
        contentViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.15
        height = contentViewHeightConstraint.constant
        
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
                return favoriteArray.count
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailsCollectionView {
            if station != nil {
                
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
                
                if app!.user!.favorites!.keys.contains(station!.id!.description){
                    isFavorite = true
                } else {
                    isFavorite = false
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
        } else {
            if followingArray.count != 0 {
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
                    return cell
                }  else {
                    //Favoritter cell
                    let row = indexPath.row - (followingArray.count + 2)
                    var cell: FavoritesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath as IndexPath) as! FavoritesCell
                    cell.activityLabel.text = "Høy"
                    cell.subscriberAmountLabel.text = "20"
                    cell.stationNameLabel.text = favoriteArray[row].name
                    cell.stationStreetLabel.text = favoriteArray[row].street! + " " + favoriteArray[row].houseNumber!
                    cell.stationCityLabel.text = favoriteArray[row].city
                    var availableConnectors = app!.findAvailableContacts(station: favoriteArray[row])
                    cell.availableContactsLabel.text = availableConnectors[0].description + "/" + availableConnectors[1].description
                    cell.station = favoriteArray[row]
                    cell = addShadowFavoritesCell(cell: cell)
                    return cell
                }
            } else {
                //Favoritter cell
                var cell: FavoritesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath as IndexPath) as! FavoritesCell
                cell.activityLabel.text = "Høy"
                cell.subscriberAmountLabel.text = "20"
                cell.stationNameLabel.text = favoriteArray[indexPath.row].name
                cell.stationStreetLabel.text = favoriteArray[indexPath.row].street
                cell.stationCityLabel.text = favoriteArray[indexPath.row].city
                var availableConnectors = app!.findAvailableContacts(station: favoriteArray[indexPath.row])
                cell.availableContactsLabel.text = availableConnectors[0].description + "/" + availableConnectors[1].description
                cell.station = favoriteArray[indexPath.row]
                cell = addShadowFavoritesCell(cell: cell)
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
            
            if followingArray.count != 0{
                if indexPath.row == 0{
                    height = 25
                } else if indexPath.row == followingArray.count + 1{
                    height = 25
                } else if indexPath.row <= followingArray.count {
                    height = 39
                } else {
                    height = self.view.frame.size.width * 0.35
                }
            }
            return CGSize(width: width, height: height)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if followingArray.count != 0{
                if indexPath.row >= followingArray.count + 2 {
                    let row = indexPath.row - (followingArray.count + 2)
                    station = favoriteArray[row]
                    self.connectors = self.app!.sortConnectors(station: station!).conn
                    detailsStartPosition(withAnimation: true)
                    detailsCollectionView.reloadData()
                    
                } else if indexPath.row != 0 && indexPath.row <= followingArray.count{
                    let row = indexPath.row - 1
                    station = followingArray[row]
                    self.connectors = self.app!.sortConnectors(station: station!).conn
                    detailsStartPosition(withAnimation: true)
                    detailsCollectionView.reloadData()
                }
            } else {
                station = favoriteArray[indexPath.row]
                detailsEngagedPosition(blur: 0.26)
            }
        }
    }
}

private typealias Delegate = Favorites
extension Delegate: CollectionViewCellDelegate {
    
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton, action: action) {
        //var indexPath = self.collectionView.indexPath(for: cell)
        
        //Remove subscription from database
        if action == .cancel {
            if startPosition {
                detailsDismissedPosition()
            } else {
                detailsStartPosition(withAnimation: true)
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        } else if action == .favorite {
            if isFavorite! {
                app!.user?.favorites?.removeValue(forKey: station!.id!.description)
                app?.setUserInDatabase(user: app!.user!)
                let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                infoCell.favoriteButton.setTitle("Legg til favoritter", for: .normal)
                infoCell.favoriteButton.layer.backgroundColor = UIColor.appleGreen().cgColor
                isFavorite = false
            } else {
                app!.user?.favorites?.updateValue(Date().getTimestamp(), forKey: station!.id!.description)
                app?.setUserInDatabase(user: app!.user!)
                let infoCell = self.detailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! InfoCell
                infoCell.favoriteButton.setTitle("Fjern fra favoritter", for: .normal)
                infoCell.favoriteButton.layer.backgroundColor = UIColor.appleOrange().cgColor
                isFavorite = true
            }
            populateFavoritesArray()
            
        } else if action == .subscribe {
            print("Subscribe")
        }
    }
}
