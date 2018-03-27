//
//  InfoCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var xibHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var xibWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var panelView: UIView!

    var realtime: Bool?
    var userComment: String?
    var connectors: [Connector]?
    
    @IBOutlet weak var screenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var stationButton: UIButton!
    
    @IBOutlet weak var detailsStack: UIStackView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var streetLabel: UILabel!
        @IBOutlet weak var realtimeLabel: UILabel!
        @IBOutlet weak var fastChargeLabel: UILabel!
        @IBOutlet weak var parkingFeeLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    @IBOutlet weak var commentsStack: UIStackView!
        @IBOutlet weak var commentsView: UITableView!
        @IBOutlet weak var commentStackWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var connectorStack: UIStackView!
        @IBOutlet weak var connectorCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsView.delegate = self
        commentsView.dataSource = self
        connectorCollectionView.delegate = self
        connectorCollectionView.dataSource = self
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
       
        commentsView.rowHeight = UITableViewAutomaticDimension
        commentsView.estimatedRowHeight = 135

        initializeApperance()
        setConstraints()
        
        commentsView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCellIdentifier")
        commentsView.register(UITableViewCell.self, forCellReuseIdentifier: "Label")

        connectorCollectionView.register(UINib(nibName: "ConnectorCell", bundle: nil), forCellWithReuseIdentifier: "ConnectorCellIdentifier")
        
        xibWidthConstraint.constant = UIScreen.main.bounds.width
        xibHeightConstraint.constant = UIScreen.main.bounds.height - 219
        
        
        
        //219 høyden på xib for best config.
        descriptionLabel.sizeToFit()
        //Sort connectors etter relevanse
        

    }
    
    func initializeApperance(){
        detailsButton.tintColor = UIColor.appleBlue()
        panelView.layer.cornerRadius = 20
        detailsStack.isHidden = false
        commentsStack.isHidden = true
        connectorStack.isHidden = true
    }
    
    func setConstraints(){
        screenWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        commentStackWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        
    }
    
    @IBAction func detailsButton(_ sender: UIButton) {
        detailsButton.tintColor = UIColor.appleBlue()
        commentsButton.tintColor = UIColor.gray
        stationButton.tintColor = UIColor.gray
        
        detailsStack.isHidden = false
        commentsStack.isHidden = true
        connectorStack.isHidden = true

    }
    
    @IBAction func commentsButton(_ sender: UIButton) {
        detailsButton.tintColor = UIColor.gray
        commentsButton.tintColor = UIColor.appleBlue()
        stationButton.tintColor = UIColor.gray

        detailsStack.isHidden = true
        commentsStack.isHidden = false
        connectorStack.isHidden = true

    }
    
    @IBAction func stationButton(_ sender: UIButton) {
        detailsButton.tintColor = UIColor.gray
        commentsButton.tintColor = UIColor.gray
        stationButton.tintColor = UIColor.appleBlue()
        detailsStack.isHidden = true
        commentsStack.isHidden = true
        connectorStack.isHidden = false

    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userComment?.replacingOccurrences(of: " ", with: "") != "" {
            let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCellIdentifier", for: indexPath as IndexPath) as! CommentCell
            cell.backgroundColor = UIColor.clear
            cell.commentLabel.text = userComment
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Label", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.text = "Ingen kommentarer."
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Kan være nil.
        print("Count", connectors!.count)
        return connectors!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ConnectorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConnectorCellIdentifier", for: indexPath as IndexPath) as! ConnectorCell
        cell.typeLabel.text = connectors![indexPath.row].connector?.description
        cell.chargeRateLabel.text = connectors![indexPath.row].chargerMode
        cell.compatibleLabel.text = "Må legges inn"
        if realtime! {
            if connectors![indexPath.row].isTaken == 0 {
                cell.isTakenLabel.text = "Ledig"
            } else {
                cell.isTakenLabel.text = "Opptatt"
            }
            
            if connectors![indexPath.row].error == 0 {
                cell.isOperationalLabel.text = ""
            } else {
                cell.isOperationalLabel.text = "Ute av drift"
            }
        } else {
            cell.isTakenLabel.text = ""
            cell.isOperationalLabel.text = ""
        }
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Sette størelsen på containerene i collectionview
        return CGSize(width: (UIScreen.main.bounds.width - 100), height: (UIScreen.main.bounds.width - 100))
    }
}
