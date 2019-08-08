//
//  BarCrawlTextField.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/7/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class BarCrawlTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        self.cornerRadius(8)
        self.backgroundColor = .gray
        self.layer.masksToBounds = true
        self.textColor = .offWhite
        self.addBorder()
    }
    
}
