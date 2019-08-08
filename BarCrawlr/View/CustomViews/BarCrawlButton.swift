//
//  Buttons.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/7/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class BarCrawlButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        self.backgroundColor = .lightBlue
        self.setTitleColor(.mainBackground, for: .normal)
        self.cornerRadius(8)
        self.addButtonShadow()
    }
    
    func addButtonShadow() {
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 3, height: 3)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
    }
    
    
}
