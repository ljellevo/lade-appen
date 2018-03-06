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

    //let database = Database()
    var app: App?
    var favoriteArray: [Station] = []
    var followingArray: [Station] = []
    var station: Station?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellWithReuseIdentifier: "FavoritesCell")
        collectionView.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "LabelCell")
        collectionView.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateFavoritesArray()
    }
    
    func populateFavoritesArray(){
        favoriteArray = []
        followingArray = []
        for station in app!.filteredStations{
            if app!.favorites.keys.contains(station.id!) {
                self.favoriteArray.append(station)
                self.followingArray.append(station)
            }
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if followingArray.count != 0{
            return favoriteArray.count + followingArray.count + 2
        } else {
            return favoriteArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                cell.stationStreetLabel.text = favoriteArray[row].street
                cell.stationCityLabel.text = favoriteArray[row].city
                cell.availableContactsLabel.text = "Ledig/" + app!.algorithms!.findAvailableContacts(station: favoriteArray[row]).description
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
            cell.availableContactsLabel.text = "Ledig/" + app!.algorithms!.findAvailableContacts(station: favoriteArray[indexPath.row]).description
            cell.station = favoriteArray[indexPath.row]
            cell = addShadowFavoritesCell(cell: cell)
            return cell
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if followingArray.count != 0{
            if indexPath.row >= followingArray.count + 2 {
                let row = indexPath.row - (followingArray.count + 2)
                station = favoriteArray[row]
                self.performSegue(withIdentifier: "toDetailsFromFavorites", sender: nil)
            } else if indexPath.row != 0 && indexPath.row <= followingArray.count{
                let row = indexPath.row - 1
                station = followingArray[row]
                self.performSegue(withIdentifier: "toDetailsFromFavorites", sender: nil)
            }
        } else {
            station = favoriteArray[indexPath.row]
            self.performSegue(withIdentifier: "toDetailsFromFavorites", sender: nil)
        }
    }
}

extension Favorites: CollectionViewCellDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromFavorites"{
            if let nextViewController = segue.destination as? Details{
                nextViewController.station = station
            }
        }
    }
    
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        //var indexPath = self.collectionView.indexPath(for: cell)
        
        //Remove subscription from database
        print("Remove button clicked")
    }
}
