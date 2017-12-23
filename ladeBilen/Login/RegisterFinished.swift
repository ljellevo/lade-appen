//
//  RegisterFinished.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit
import Firebase

class RegisterFinished: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

    var connectors: [String] = []
    var email: String?
    var firstname: String?
    var lastname: String?
    var fastcharge: Bool?
    var parkingfee: Bool?
    var cloudStorage: Bool?
    var notifications: Bool?
    var notificationsDuration: Int?
    var connector: Int?
    var connectorIndexPath: IndexPath?
    var connectorSelected: Bool = false
    
    @IBOutlet weak var whitePannel: UIView!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var connectorCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whitePannel.layer.cornerRadius = 20
        finishedButton.layer.cornerRadius = 20
        connectorCollectionView.delegate = self
        connectorCollectionView.dataSource = self
        
        connectorCollectionView.register(UINib(nibName: "RegisterFinishedConnectorCell", bundle: nil), forCellWithReuseIdentifier: "RegisterFinishedConnectorCellIdentifier")
        getConnectors()
        



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func finishedButton(_ sender: UIButton) {
        if connector != nil {
            let user = User(email: email!, firstname: firstname!, lastname: lastname!, fastCharge: fastcharge!, parkingFee: parkingfee!, cloudStorage: cloudStorage!, notifications: notifications!, notificationDuration: notificationsDuration!, connector: connector!)
            
        }
    }
    


}
