//
//  InfoCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell{
    
    @IBOutlet weak var panelView: UIView!
    
    @IBOutlet weak var screenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var picturesButton: UIButton!    
    @IBOutlet weak var descriptionOfLocationTextView: UITextView!
    @IBOutlet weak var descriptionOfLocationHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionOfLocationTextView.textContainer.lineFragmentPadding = 0
        self.descriptionOfLocationTextView.textContainerInset = .zero
        self.panelView.layer.cornerRadius = 20
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        screenWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        
        //descriptionOfLocationTextView.text = "Liten tekst, hvordan blir dette håndtert?"
        descriptionOfLocationHeightConstraint.constant = (self.descriptionOfLocationTextView.sizeThatFits(self.descriptionOfLocationTextView.bounds.size).height + 20)
        print(descriptionOfLocationHeightConstraint.constant)
    }
}
