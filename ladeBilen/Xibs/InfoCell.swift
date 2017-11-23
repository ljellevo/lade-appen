//
//  InfoCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var fastChargeStationLabel: UILabel!
    
    @IBOutlet weak var parkingFeeLabel: UILabel!
    
    @IBOutlet weak var descriptionOfLocationTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionOfLocationTextView.textContainer.lineFragmentPadding = 0
        self.descriptionOfLocationTextView.textContainerInset = .zero
        // Initialization code
    }

}
