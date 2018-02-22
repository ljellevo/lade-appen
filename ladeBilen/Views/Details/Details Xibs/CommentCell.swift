//
//  CommentCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentBackgroundView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentBackgroundView.layer.masksToBounds = true
        commentBackgroundView.layer.cornerRadius = 10

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
