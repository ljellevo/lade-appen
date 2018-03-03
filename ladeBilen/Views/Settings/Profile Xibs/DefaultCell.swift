//
//  DefaultCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class DefaultCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
