//
//  NotificationView.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 14.03.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setBackgroundColor(){
        super.backgroundColor = UIColor.red
    }
}
