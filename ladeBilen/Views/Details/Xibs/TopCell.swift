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
    @IBOutlet weak var realtimeIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        screenWidthConstraint.constant = UIScreen.main.bounds.width
        
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.realtimeIcon.alpha = 0.0
        }, completion: nil)
        
        
    }
    
    


}
