//
//  ConnectorsCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class ConnectorCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var chargeRateLabel: UILabel!
    @IBOutlet weak var compatibleLabel: UILabel!
    @IBOutlet weak var isTakenLabel: UILabel!
    @IBOutlet weak var isOperationalLabel: UILabel!
    
    override func awakeFromNib() { 
        super.awakeFromNib()
        // Initialization code
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.view.layer.borderColor = UIColor.green.cgColor

            } else {
                self.view.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
}
