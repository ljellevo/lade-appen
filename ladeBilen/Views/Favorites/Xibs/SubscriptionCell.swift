//
//  SubscriptionCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit


class SubscriptionCell: UICollectionViewCell {
    
    var station: Station?
    var timeTo: Int64 = 0
    var timer = Timer()
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cancelSubscriptionButton: UIButton!
    weak var delegate: CollectionViewCellDelegate?

    @IBOutlet weak var firstSeparator: UIView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var secondSeparator: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        //view.layer.cornerRadius = 10
        firstSeparator.layer.cornerRadius = 1
        secondSeparator.layer.cornerRadius = 1
        countdownSubscriptions()
    }
    
    
//    timer.invalidate()
    
    @IBAction func cancelSubscriptionButton(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: cancelSubscriptionButton, action: .unsubscribe)
    }
    
    func countdownSubscriptions() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        let timeRemaining = NSNumber(value: (timeTo.subtractingReportingOverflow(Date().getTimestamp())).partialValue).intValue
        
        var timeLabel: String = ""
        if timeRemaining > 3600 {
            let hours = Int(timeRemaining) / 3600
            let minutes = Int(timeRemaining) / 60 % 60
            timeLabel = hours.description + "t " + minutes.description + "m"
        } else if timeRemaining > 60 {
            let minutes = Int(timeRemaining) / 60 % 60
            let seconds = Int(timeRemaining) % 60
            timeLabel = minutes.description + "m " + seconds.description + "s"
        } else {
            let seconds = Int(timeRemaining) % 60
            timeLabel = seconds.description + "s"
        }
        
        remainingTimeLabel.text = timeLabel
    }
}
