//
//  FavoritesCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 24.02.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import UIKit

class FavoritesCell: UICollectionViewCell {
    
    var station: Station!
    weak var delegate: FavoritesCellDelegate?

    
    @IBOutlet weak var indicatorColor: UIView!
    
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var subscriberAmountLabel: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationStreetLabel: UILabel!
    @IBOutlet weak var stationCityLabel: UILabel!
    
    @IBOutlet weak var availableConntactsLabelMessage: UILabel!
    @IBOutlet weak var availableContactsLabel: UILabel!
    @IBOutlet weak var isAvailableLabel: UILabel!
    
    @IBOutlet weak var toDetailsButton: UIButton!
    
    @IBOutlet weak var realtimeActivityStackView: UIStackView!
    @IBOutlet weak var realtimeSeperatorStackView: UIStackView!
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contactsStackView: UIStackView!
    @IBOutlet weak var showOnMapButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configLayout()
    }
    
    func configLayout(){
        
        //indicatorColor.layer.cornerRadius = 10
        whitePanel.layer.cornerRadius = 0
        separatorLine.layer.cornerRadius = 1
        showOnMapButton.tintColor = UIColor.markerRed()
    }
    
    func isRealtime(realtime: Bool){
        if !realtime {
            realtimeActivityStackView.isHidden = true
            realtimeSeperatorStackView.isHidden = true
            contactsStackView.isHidden = true
            indicatorColor.backgroundColor = UIColor.appTheme()
            return
        }
        realtimeActivityStackView.isHidden = false
        realtimeSeperatorStackView.isHidden = false
        contactsStackView.isHidden = false
    }
    
    
    @IBAction func showOnMap(_ sender: UIButton) {
        delegate?.favoriteShowOnMap(self, buttonTapped: showOnMapButton, station: station!)
    }
    
    @IBAction func toDetailsButton(_ sender: UIButton) {
        
    }
}
