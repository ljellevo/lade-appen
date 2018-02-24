//
//  FavoritesCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}

class FavoritesCell: UICollectionViewCell {
    
    var station: Station?

    
    @IBOutlet weak var indicatorColor: UIView!
    
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var subscriberAmountLabel: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationStreetLabel: UILabel!
    @IBOutlet weak var stationCityLabel: UILabel!
    
    @IBOutlet weak var availableContactsLabel: UILabel!
    @IBOutlet weak var isAvailableLabel: UILabel!
    
    @IBOutlet weak var toDetailsButton: UIButton!
    weak var delegate: CollectionViewCellDelegate?

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configLayout()
    }
    
    func configLayout(){
        
        indicatorColor.layer.cornerRadius = 10
        whitePanel.layer.cornerRadius = 0
        separatorLine.layer.cornerRadius = 1
    }
    
    

    @IBAction func toDetailsButton(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: toDetailsButton)
    }
}
