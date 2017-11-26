//
//  CommentCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet weak var commenTextViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.layer.cornerRadius = 20
        
        commenTextViewHeightConstraint.constant = (self.commentTextView.sizeThatFits(self.commentTextView.bounds.size).height + 40)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
