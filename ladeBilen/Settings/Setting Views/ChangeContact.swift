//
//  ChangeContact.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 01.01.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase

class ChangeContact: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var connectors: [String] = []
    var connector: Int?

    
    @IBOutlet weak var connectorCollectionView: UICollectionView!
    @IBOutlet weak var whitePanel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whitePanel.layer.cornerRadius = 20

        connectorCollectionView.delegate = self
        connectorCollectionView.dataSource = self
        
        connectorCollectionView.register(UINib(nibName: "RegisterFinishedConnectorCell", bundle: nil), forCellWithReuseIdentifier: "RegisterFinishedConnectorCellIdentifier")
        getConnectors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getConnectors(){
        let ref = FIRDatabase.database().reference()
        ref.child("Connectors").observe(.value, with: { (snapshot) in
            print(snapshot)
            
            for children in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                print(children.value as! String)
                self.connectors.append(children.value as! String)
            }
            self.connectorCollectionView.reloadData()
            
        }, withCancel: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return connectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RegisterFinishedConnectorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterFinishedConnectorCellIdentifier", for: indexPath as IndexPath) as! RegisterFinishedConnectorCell
        if connectors.count != 0{
            cell.connectorLabel.text = connectors[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 100), height: (UIScreen.main.bounds.width - 100))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RegisterFinishedConnectorCell
        cell.isSelected = true
        connector = indexPath.row
    }
}
