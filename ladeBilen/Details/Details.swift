//
//  Details.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 21.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class Details: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var station: Station?
    let database = Database()
    var isFavorite: Bool = false

    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "ImageCellIdentifier")
        self.collectionView.register(UINib(nibName: "InfoCell", bundle: nil), forCellWithReuseIdentifier: "InfoCellIdentifier")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 95)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        checkIfFavorite()
    }
    
    func checkIfFavorite(){
        for favorite in GlobalResources.favorites{
            if favorite == station?.id {
                isFavorite = true
                favoriteBarButtonItem.image = #imageLiteral(resourceName: "FavoriteFilledSet")
            }
        }
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell: TopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath as IndexPath) as! TopCell
            //Mulige kontakter
            //Har kompatiblitet

            return cell
        } else {
            let cell: InfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCellIdentifier", for: indexPath as IndexPath) as! InfoCell
            cell.nameLabel.text = station?.name
            cell.streetLabel.text = (station?.street)! + " " + (station?.houseNumber)!
            cell.realtimeLabel.text = "Realtime: " + (station?.realtimeInfo)!
            cell.fastChargeLabel.text = "Mangler"
            cell.parkingFeeLabel.text = "Parkerings avgift: " + (station?.parkingFee)!
            cell.userComment = station?.userComment
            cell.descriptionLabel.text = station?.descriptionOfLocation
            cell.connectors = station?.conn
            return cell
        }
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
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        if isFavorite {
            database.removeFavoriteInDatabase(id: station!.id!)
            favoriteBarButtonItem.image = #imageLiteral(resourceName: "FavoriteSet")
            isFavorite = false
        } else {
            database.addFavoriteInDatabase(id: station!.id!)
            favoriteBarButtonItem.image = #imageLiteral(resourceName: "FavoriteFilledSet")
            isFavorite = true
        }        
    }
    
    @IBAction func followButton(_ sender: UIBarButtonItem) {
        //Legg til i følge, hvis man følger så fjerner man entryen.
        
    }
    
}
