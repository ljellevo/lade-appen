//
//  SubscriptionCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}

class SubscriptionCell: UICollectionViewCell {
    
    var station: Station?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cancelSubscriptionButton: UIButton!
    weak var delegate: CollectionViewCellDelegate?

    @IBOutlet weak var firstSeparator: UIView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var secondSeparator: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        view.layer.cornerRadius = 10
        firstSeparator.layer.cornerRadius = 1
        secondSeparator.layer.cornerRadius = 1
    }
    
    @IBAction func cancelSubscriptionButton(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: cancelSubscriptionButton)
    }
    

}
