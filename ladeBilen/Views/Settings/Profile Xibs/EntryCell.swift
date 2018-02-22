//
//  EntryCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 26.12.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
