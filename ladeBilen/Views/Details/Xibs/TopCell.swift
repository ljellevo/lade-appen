//
//  ImageCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class TopCell: UICollectionViewCell {

    
    @IBOutlet weak var screenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var connectorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        screenWidthConstraint.constant = UIScreen.main.bounds.width


    }

}
