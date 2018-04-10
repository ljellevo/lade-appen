//
//  LabelCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 10.04.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class StartCell: UICollectionViewCell {

    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
