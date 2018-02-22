//
//  RegisterFinishedConnectorCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class RegisterFinishedConnectorCell: UICollectionViewCell {

    @IBOutlet weak var connectorImage: UIImageView!
    @IBOutlet weak var connectorLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
