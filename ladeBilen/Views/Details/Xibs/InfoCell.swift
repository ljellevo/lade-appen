//
//  InfoCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell{
    
    var run: Bool = false
    var realtime: Bool?
    var userComment: String?
    var connectors: [Connector]?
    var compatibleConntacts: Int?
    weak var delegate: CollectionViewCellDelegate?

    
    @IBOutlet weak var xibHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var xibWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var panelView: UIView!

    @IBOutlet weak var screenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var stationButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var detailsStack: UIStackView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var streetLabel: UILabel!
        @IBOutlet weak var realtimeLabel: UILabel!
        @IBOutlet weak var fastChargeLabel: UILabel!
        @IBOutlet weak var parkingFeeLabel: UILabel!
        @IBOutlet weak var favoriteButton: UIButton!
        @IBOutlet weak var subscribeButton: UIButton!
        @IBOutlet weak var realtimeView: UIView!
        @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var commentsStack: UIStackView!
        @IBOutlet weak var commentsView: UITableView!
        @IBOutlet weak var commentStackWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var connectorStack: UIStackView!
        @IBOutlet weak var connectorCollectionView: UICollectionView!
    
    @IBOutlet weak var imageStack: UIStackView!
        @IBOutlet weak var stationImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        screenWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        commentStackWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        
        loadDetailsElement()
        loadCommentsElement()
        loadConnectorElement()
        loadImageElement()
        
        detailsButton.tintColor = UIColor.themeBlue()
        detailsStack.isHidden = false
        commentsStack.isHidden = true
        connectorStack.isHidden = true
        imageStack.isHidden = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
       
        xibWidthConstraint.constant = UIScreen.main.bounds.width
        xibHeightConstraint.constant = UIScreen.main.bounds.height * 0.6
        descriptionLabel.sizeToFit()
    }
    
    @IBAction func detailsButton(_ sender: UIButton) {
        setActiveViewFor(element: .InfoElement)
    }
    
    @IBAction func commentsButton(_ sender: UIButton) {
        setActiveViewFor(element: .CommentsElement)
    }
    
    @IBAction func stationButton(_ sender: UIButton) {
        setActiveViewFor(element: .ConnectorElement)
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
        setActiveViewFor(element: .ImageElement)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: cancelButton, action: .cancel)
    }
    
    func setActiveViewFor(element: elements) {
        switch element {
        case .InfoElement:
            detailsButton.tintColor = UIColor.themeBlue()
            commentsButton.tintColor = UIColor.gray
            stationButton.tintColor = UIColor.gray
            imageButton.tintColor = UIColor.gray
            
            detailsStack.isHidden = false
            commentsStack.isHidden = true
            connectorStack.isHidden = true
            imageStack.isHidden = true
        case .CommentsElement:
            detailsButton.tintColor = UIColor.gray
            commentsButton.tintColor = UIColor.themeBlue()
            stationButton.tintColor = UIColor.gray
            imageButton.tintColor = UIColor.gray

            
            detailsStack.isHidden = true
            commentsStack.isHidden = false
            connectorStack.isHidden = true
            imageStack.isHidden = true

        case .ConnectorElement:
            detailsButton.tintColor = UIColor.gray
            commentsButton.tintColor = UIColor.gray
            stationButton.tintColor = UIColor.themeBlue()
            imageButton.tintColor = UIColor.gray

            
            detailsStack.isHidden = true
            commentsStack.isHidden = true
            connectorStack.isHidden = false
            imageStack.isHidden = true

            
        case .ImageElement:
            detailsButton.tintColor = UIColor.gray
            commentsButton.tintColor = UIColor.gray
            stationButton.tintColor = UIColor.gray
            imageButton.tintColor = UIColor.themeBlue()
            
            
            detailsStack.isHidden = true
            commentsStack.isHidden = true
            connectorStack.isHidden = true
            imageStack.isHidden = false
        }
    }

    @IBAction func favoriteButton(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: cancelButton, action: .favorite)
    }
    
    @IBAction func subscribeButton(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: cancelButton, action: .subscribe)
    }
}


private typealias DetailsElement = InfoCell
extension DetailsElement {
    func loadDetailsElement(){
        favoriteButton.layer.cornerRadius = 10
        subscribeButton.layer.cornerRadius = 10
        realtimeView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func killAllAnimations(){
        run = false
    }
    
    func animateRealtime(){
        var x = 5
        let y = 10
        var counter = 0
        
        let firstDot = UIView(frame: CGRect(x: x, y: y, width: 10, height: 10))
        x += 15
        let secondDot = UIView(frame: CGRect(x: x, y: y, width: 10, height: 10))
        x += 15
        let thirdDot = UIView(frame: CGRect(x: x, y: y, width: 10, height: 10))
        
        firstDot.backgroundColor = UIColor.appleGreen()
        firstDot.layer.cornerRadius = 5
        firstDot.alpha = 0.0
        
        secondDot.backgroundColor = UIColor.appleYellow()
        secondDot.layer.cornerRadius = 5
        secondDot.alpha = 0.0

        thirdDot.backgroundColor = UIColor.appleRed()
        thirdDot.layer.cornerRadius = 5
        thirdDot.alpha = 0.0

        let dots = [firstDot, secondDot, thirdDot]
        self.realtimeView.addSubview(firstDot)
        self.realtimeView.addSubview(secondDot)
        self.realtimeView.addSubview(thirdDot)
        run = true
        animation(dots: dots)
    }
    
    func animation(dots: [UIView]){
        if realtime! {
            UIView.animate(withDuration: 0.25, delay: 0.5, options: [.allowUserInteraction], animations: {
                dots[0].alpha = 1.0
            }) { (completion) in
                UIView.animate(withDuration: 0.25, delay: 0.5, options: [.allowUserInteraction], animations: {
                    dots[1].alpha = 1.0
                }, completion: { (completed) in
                    UIView.animate(withDuration: 0.25, delay: 0.5, options: [.allowUserInteraction], animations: {
                        dots[2].alpha = 1.0
                    }, completion: { (com) in
                        UIView.animate(withDuration: 0.25, delay: 0.5, options: [.allowUserInteraction], animations: {
                            dots[0].alpha = 0.0
                            dots[1].alpha = 0.0
                            dots[2].alpha = 0.0
                        }, completion: { (c) in
                            self.animation(dots: dots)
                        })
                        
                    })
                })
            }
        }
    }
}

private typealias CommentsElement = InfoCell
extension CommentsElement: UITableViewDelegate, UITableViewDataSource {
    
    func loadCommentsElement(){
        commentsView.delegate = self
        commentsView.dataSource = self
        
        commentsView.rowHeight = UITableViewAutomaticDimension
        commentsView.estimatedRowHeight = 135
        
        commentsView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCellIdentifier")
        commentsView.register(UITableViewCell.self, forCellReuseIdentifier: "Label")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userComment!.replacingOccurrences(of: " ", with: "") != "" {
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

}

private typealias ConnectorElement = InfoCell
extension ConnectorElement: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout{
    
    func loadConnectorElement(){
        connectorCollectionView.delegate = self
        connectorCollectionView.dataSource = self
        
        connectorCollectionView.register(UINib(nibName: "ConnectorCell", bundle: nil), forCellWithReuseIdentifier: "ConnectorCellIdentifier")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Kan være nil.
        print("Count", connectors!.count)
        return connectors!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ConnectorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConnectorCellIdentifier", for: indexPath as IndexPath) as! ConnectorCell
        
        //Endre fra description til int sammenligning
        cell.typeLabel.text = connectors![indexPath.row].connector?.description
        cell.chargeRateLabel.text = connectors![indexPath.row].chargerMode?.description
        
        if connectors![indexPath.row].chargerMode?.description == "1" {
            cell.chargeRateLabel.text = "Normal"
        } else if connectors![indexPath.row].chargerMode?.description == "2" {
            cell.chargeRateLabel.text = "Semi-Hurtig"
        } else if connectors![indexPath.row].chargerMode?.description == "3" {
            cell.chargeRateLabel.text = "Semi-Hurtig"
        } else {
            cell.chargeRateLabel.text = "Hurtig"
            
        }
        
        if realtime! {
            if connectors![indexPath.row].isTaken! == 0{
                cell.isTakenLabel.text = "Ledig"
            } else {
                cell.isTakenLabel.text = "Opptatt"
            }
            
            if connectors![indexPath.row].error == 0 {
                cell.isOperationalLabel.text = ""
            } else {
                cell.isOperationalLabel.text = "Ute av drift"
                cell.isTakenLabel.text = ""
                
            }
        } else {
            cell.isTakenLabel.text = ""
            cell.isOperationalLabel.text = ""
        }
        
        
        
        if compatibleConntacts != nil && realtime! {
            if compatibleConntacts! > indexPath.row {
                cell.view.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.view.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            if compatibleConntacts! > indexPath.row && connectors![indexPath.row].isTaken == 0 && connectors![indexPath.row].error == 0 {
                cell.view.layer.borderColor = UIColor.darkGreen().cgColor
            } else if compatibleConntacts! > indexPath.row && connectors![indexPath.row].isTaken == 1 && connectors![indexPath.row].error == 0 {
                cell.view.layer.borderColor = UIColor.darkYellow().cgColor
            }
        } else {
            cell.view.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Sette størelsen på containerene i collectionview
        return CGSize(width: (UIScreen.main.bounds.width - 100), height: (UIScreen.main.bounds.width - 100))
    }

}

private typealias ImageElement = InfoCell
extension ImageElement {
    func loadImageElement(){
        stationImage.layer.masksToBounds = true
        stationImage.layer.cornerRadius = 10
    }
}

