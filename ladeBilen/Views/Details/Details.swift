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
    var app: App?
    var isFavorite: Bool = false
    var connectors: [Connector]?
    var countCompatible: Int?

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
        self.connectors = self.app!.sortConnectors(connectors: station!.conn)
        print(station!.conn.count)
        
        //Må lytte etter kontakter ikke stasjon
        app?.listenOnStation(stationId: station!.id!, done: { station in
            self.station = station
            self.connectors = self.app!.sortConnectors(connectors: station.conn)


            DispatchQueue.main.async {
                
                let topCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! TopCell
                var availableConntacts: Int = 0
                
                for conn in station.conn {
                    if conn.error == 0 && conn.isTaken == 0 && self.app!.checkIfConntactIsAppliable(connector: conn) {
                        availableConntacts += 1
                    }
                }
                
                let compatibleConntacts: Int = self.app!.findAvailableContacts(station: station)
                topCell.connectorLabel.text = availableConntacts.description + "/" + compatibleConntacts.description
 
                let infoCell = self.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! InfoCell
                infoCell.connectors = self.connectors
                infoCell.connectorCollectionView.reloadData()
                /*
                UIView.performWithoutAnimation {
                    self.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
                }
 */
 
                //self.collectionView.reloadData()
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        app?.detachListenerOnStation(stationId: station!.id!)
    }
    


    
    func checkIfFavorite(){
        if app!.user!.favorites!.keys.contains(station!.id!.description){
            isFavorite = true
            favoriteBarButtonItem.image = #imageLiteral(resourceName: "FavoriteFilledSet")
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
            var availableConntacts: Int = 0
            for conn in station!.conn {
                if conn.error == 0 && conn.isTaken == 0 && app!.checkIfConntactIsAppliable(connector: conn) {
                    availableConntacts += 1
                }
            }
            
            let compatibleConntacts: Int = app!.findAvailableContacts(station: station!)
            cell.connectorLabel.text = availableConntacts.description + "/" + compatibleConntacts.description

            countCompatible = compatibleConntacts
            
            if station!.realtimeInfo! {
                cell.realtimeIcon.image = #imageLiteral(resourceName: "OnlineSet")
            } else {
                cell.realtimeIcon.image = #imageLiteral(resourceName: "OfflineSet")
            }
            return cell
        } else {
            let cell: InfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCellIdentifier", for: indexPath as IndexPath) as! InfoCell
            cell.connectorCollectionView.reloadData()
            cell.realtime = station?.realtimeInfo
            cell.nameLabel.text = station?.name
            cell.compatibleConntacts = countCompatible
            cell.streetLabel.text = (station?.street)! + " " + (station?.houseNumber)!
            cell.realtimeLabel.text = "Realtime: " + (station?.realtimeInfo)!.description
            cell.fastChargeLabel.text = "Mangler"
            cell.parkingFeeLabel.text = "Parkerings avgift: " + (station?.parkingFee)!
            cell.userComment = station?.userComment
            cell.descriptionLabel.text = station?.descriptionOfLocation
            cell.connectors = connectors!

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
            app!.user?.favorites?.removeValue(forKey: station!.id!.description)
            app?.setUserInDatabase(user: app!.user!)
            self.favoriteBarButtonItem.image = #imageLiteral(resourceName: "FavoriteSet")
            self.isFavorite = false
        } else {
            app!.user?.favorites?.updateValue(Date().getTimestamp(), forKey: station!.id!.description)
            app?.setUserInDatabase(user: app!.user!)
            self.favoriteBarButtonItem.image = #imageLiteral(resourceName: "FavoriteFilledSet")
            self.isFavorite = true
        }        
    }
    

    
    @IBAction func followButton(_ sender: UIBarButtonItem) {
        //Legg til i følge, hvis man følger så fjerner man entryen.
    }
    
}
