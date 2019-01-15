//
//  styleExtentions.swift
//  ladeBilen
//
//  Created by Ludvig Ellevold on 16.06.2017.
//  Copyright © 2017 Ludvig Ellevold. All rights reserved.
//

import UIKit


extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UITextField {
    func setBottomBorderGray() {
        self.borderStyle = UITextField.BorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setBottomBorderRed() {
        self.borderStyle = UITextField.BorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIColor {
    //Used for buttons in details view
    static func themeBlue() -> UIColor {
        return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    }
    
    static func darkGreen() -> UIColor {
        return UIColor(red: 0.1059, green: 0.5765, blue: 0, alpha: 1.0)
    }
    
    static func darkYellow() -> UIColor {
        return UIColor(red: 0.898, green: 0.7922, blue: 0, alpha: 1.0)
    }

    static func appleRed() -> UIColor {
        return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
    }
    
    static func appleOrange() -> UIColor {
        return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
    }
    
    static func appleYellow() -> UIColor {
        return UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
    }
    
    static func appleGreen() -> UIColor {
        return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
    }
    
    static func appleTeal() -> UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
    }
    
    static func appleBlue() -> UIColor {
        return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    }
    
    static func applePurple() -> UIColor {
        return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
    }
    
    static func applePink() -> UIColor {
        return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
    }
    
    static func sunflower() -> UIColor {
        return UIColor(red:0.97, green:0.80, blue:0.27, alpha:1.0)
    }
    
    static func casablanca() -> UIColor {
        return UIColor(red:0.95, green:0.67, blue:0.32, alpha:1.0)
    }
    
    static func pictonBlue() -> UIColor {
        return UIColor(red:0.35, green:0.60, blue:0.83, alpha:1.0)
    }
    
    static func pictonBlueDisabled() -> UIColor {
        return UIColor(red:0.55, green:0.68, blue:0.80, alpha:1.0)
    }
    
    static func faluRed() -> UIColor {
        return UIColor(red:0.53, green:0.13, blue:0.07, alpha:1.0)
    }
    
    static func appTheme() -> UIColor {
        return UIColor(red:0.28, green:0.36, blue:0.52, alpha:1.0)
    }
    
    static func appThemeDark() -> UIColor {
        return UIColor(red:0.19, green:0.25, blue:0.36, alpha:1.0)
    }
    
    static func fruitSalad() -> UIColor {
        return UIColor(red:0.35, green:0.65, blue:0.30, alpha:1.0)
    }
    
    
    
    
    
    
    
    
    
}

class SearchBarContainerView: UIView {
    
    let searchBar: UISearchBar
    
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        
        addSubview(searchBar)
    }
    
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        //view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


