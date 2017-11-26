//
//  InfoCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell{
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var picturesButton: UIButton!    
    @IBOutlet weak var descriptionOfLocationTextView: UITextView!
    
    @IBOutlet weak var descriptionOfLocationHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionOfLocationTextView.textContainer.lineFragmentPadding = 0
        self.descriptionOfLocationTextView.textContainerInset = .zero
        
        descriptionOfLocationHeightConstraint.constant = self.descriptionOfLocationTextView.sizeThatFits(self.descriptionOfLocationTextView.bounds.size).height
    }
}
