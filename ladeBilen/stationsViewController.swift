//
//  stationsViewController.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 20.07.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit


class stationsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var connectorScrollView: UIScrollView!
    
    
    let connectorTypes: [String] = ["Hurtig", "Hurtig", "Standard", "Standard"]
    let compatible: [String] = ["Ledig", "Optatt", "Ledig", "Ledig"]
    let section: [String] = ["Info"]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
}
