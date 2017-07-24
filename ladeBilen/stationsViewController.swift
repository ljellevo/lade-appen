//
//  stationsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.07.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class collectionViewCells: UICollectionViewCell {
    @IBOutlet weak var connectorTypeLabel: UILabel!
    @IBOutlet weak var connectorSpeedLabel: UILabel!
    @IBOutlet weak var connectorCapacityLabel: UILabel!
    @IBOutlet weak var connectorPaymentMethodLabel: UILabel!

    @IBOutlet weak var connectorErrorStatusLabel: UILabel!
    @IBOutlet weak var connectorStatusLabel: UILabel!
    @IBOutlet weak var connectorFrameView: UIView!
}


class stationsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var connectorScrollView: UIScrollView!
    var collectionLayout = UICollectionViewFlowLayout()
    
    
    
    let connectorType: [String] = ["CCS", "CHAdeMO", "Schuko", "Schuko"]
    let connectorSpeed: [String] = ["Hurtig", "Hurtig", "Standard", "Standard"]
    let connectorCapacity: [String] = ["20A - 230v", "30A - 230v", "10A - 230v", "10A - 230v"]
    let connectorPaymentMethod: [String] = ["Telefon", "Telefon", "Lås", "Lås"]
    let connectorErrorStatus: [String] = ["Fungerer", "Fungerer", "Fungerer ikke", "Fungerer"]
    let connectorStatus: [String] = ["Opptatt", "Ledig", "Ingen info", "Ingen info"]
    
    
    let reuseIdentifier = "collectionCell"

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return connectorType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! collectionViewCells
        cell.connectorTypeLabel?.text = connectorType[indexPath.row]
        cell.connectorSpeedLabel?.text = connectorSpeed[indexPath.row]
        cell.connectorCapacityLabel?.text = connectorCapacity[indexPath.row]
        cell.connectorPaymentMethodLabel?.text = connectorPaymentMethod[indexPath.row]
        cell.connectorErrorStatusLabel?.text = connectorErrorStatus[indexPath.row]
        cell.connectorStatusLabel?.text = connectorStatus[indexPath.row]
        cell.connectorFrameView.layer.cornerRadius = 20
        cell.connectorFrameView.layer.shadowColor = UIColor.black.cgColor
        cell.connectorFrameView.layer.shadowOffset = CGSize(width: 0.5, height: 4.0); //Here your control your spread
        cell.connectorFrameView.layer.shadowOpacity = 0.5
        cell.connectorFrameView.layer.shadowRadius = 5.0 //Here your control your blur
        return cell
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (self.collectionView!.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<collectionView.visibleCells.count {
            let cell = collectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = collectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.collectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell()
        }
    }
 
    
    
    
    
    
    
    
    
    
    
    
}
