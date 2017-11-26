//
//  Details.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 21.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class Details: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var station: Station?

    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(station as Any)
        self.collectionView.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "ImageCellIdentifier")
        self.collectionView.register(UINib(nibName: "InfoCell", bundle: nil), forCellWithReuseIdentifier: "InfoCellIdentifier")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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

            return cell
        } else {
            let cell: InfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCellIdentifier", for: indexPath as IndexPath) as! InfoCell
            cell.descriptionOfLocationTextView.text = station?.descriptionOfLocation
            /*
            cell.nameLabel.text = station?.name
            cell.streetLabel.text = station?.street
            cell.fastChargeStationLabel.text = String(describing: station?.availableChargingPoints)
            cell.parkingFeeLabel.text = station?.parkingFee
            cell.descriptionOfLocationTextView.text = station?.descriptionOfLocation
 */
            

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self.view.bounds.size.width, height: 94.0)
        } else {
            return CGSize(width: self.view.bounds.size.width, height: (UIScreen.main.bounds.height - 200))
        }
    }
    
    
    
    
    
    


}
