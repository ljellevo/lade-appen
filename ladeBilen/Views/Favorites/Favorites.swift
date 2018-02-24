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

    let database = Database()
    var favoriteArray: [Station] = []
    var station: Station?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellWithReuseIdentifier: "FavoritesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateFavoritesArray()
    }
    
    
    func populateFavoritesArray(){
        favoriteArray = []
        for station in GlobalResources.stations{
            for favorite in GlobalResources.favorites{
                if station.id == favorite {
                    self.favoriteArray.append(station)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: FavoritesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath as IndexPath) as! FavoritesCell
        cell.delegate = self as CollectionViewCellDelegate
        cell.activityLabel.text = "Høy"
        cell.subscriberAmountLabel.text = "20"
        cell.stationNameLabel.text = favoriteArray[indexPath.row].name
        cell.stationStreetLabel.text = favoriteArray[indexPath.row].street
        cell.stationCityLabel.text = favoriteArray[indexPath.row].city
        cell.station = favoriteArray[indexPath.row]
        cell = addShadow(cell: cell)
        return cell
    }
    
    func addShadow(cell: FavoritesCell) -> FavoritesCell{
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
        let height = self.view.frame.size.width * 0.4
        let width  = self.view.frame.size.width * 0.9
        return CGSize(width: width, height: height)
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
        var indexPath = self.collectionView.indexPath(for: cell)
        station = favoriteArray[(indexPath?.row)!]
        self.performSegue(withIdentifier: "toDetailsFromFavorites", sender: nil)
    }
}
