//
//  InfoCell.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 23.11.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{

    
    
    @IBOutlet weak var panelView: UIView!
    var userComment: String?
    
    @IBOutlet weak var screenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var picturesButton: UIButton!
    
    @IBOutlet weak var detailsStack: UIStackView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var streetLabel: UILabel!
        @IBOutlet weak var realtimeLabel: UILabel!
        @IBOutlet weak var fastChargeLabel: UILabel!
        @IBOutlet weak var parkingFeeLabel: UILabel!
        @IBOutlet weak var descriptionOfLocationTextView: UITextView!
            @IBOutlet weak var descriptionOfLocationHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var commentsStack: UIStackView!
        @IBOutlet weak var commentsView: UITableView!
        @IBOutlet weak var commentStackWidthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsView.delegate = self
        commentsView.dataSource = self
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
       
        commentsView.rowHeight = UITableViewAutomaticDimension
        commentsView.estimatedRowHeight = 135

        initializeApperance()
        setConstraints()
        
        commentsView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCellIdentifier")
        
        print(descriptionOfLocationHeightConstraint.constant)
    }
    
    func initializeApperance(){
        detailsButton.tintColor = UIColor.blue
        descriptionOfLocationTextView.textContainer.lineFragmentPadding = 0
        descriptionOfLocationTextView.textContainerInset = .zero
        panelView.layer.cornerRadius = 20
        detailsStack.isHidden = false
        commentsStack.isHidden = true
    }
    
    func setConstraints(){
        screenWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        commentStackWidthConstraint.constant = (UIScreen.main.bounds.width - 40)
        
        descriptionOfLocationHeightConstraint.constant = (self.descriptionOfLocationTextView.sizeThatFits(self.descriptionOfLocationTextView.bounds.size).height + 20)
    }
    
    @IBAction func detailsButton(_ sender: UIButton) {
        detailsButton.tintColor = UIColor.blue
        commentsButton.tintColor = UIColor.gray
        picturesButton.tintColor = UIColor.gray
        commentsStack.isHidden = true
        detailsStack.isHidden = false
        self.layoutIfNeeded()
        print(commentsStack.isHidden)
    }
    
    @IBAction func commentsButton(_ sender: UIButton) {
        detailsButton.tintColor = UIColor.gray
        commentsButton.tintColor = UIColor.blue
        picturesButton.tintColor = UIColor.gray
        commentsStack.isHidden = false
        detailsStack.isHidden = true
        self.layoutIfNeeded()
        print(commentsStack.isHidden)
    }
    
    @IBAction func picturesButton(_ sender: UIButton) {
        detailsButton.tintColor = UIColor.gray
        commentsButton.tintColor = UIColor.gray
        picturesButton.tintColor = UIColor.blue
        detailsStack.isHidden = true
        commentsStack.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCellIdentifier", for: indexPath as IndexPath) as! CommentCell
        cell.backgroundColor = UIColor.clear
        cell.commentTextView.text = userComment
        return cell

    }
}
