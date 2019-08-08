//
//  StyleGuide.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/7/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
extension UIView {
    
    func cornerRadius(_ radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
    }
    
    func addBorder(width: CGFloat = 1, color: UIColor = UIColor.borderHighlight) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}

extension UIColor {
    static let mainBackground = UIColor(named: "backgroundColor")!
    static let darkBlue = UIColor(named: "darkBlue")!
    static let lightBlue = UIColor(named: "lightBlue")!
    static let dullBlue = UIColor(named: "dullBlue")!
    static let offWhite = UIColor(named: "offWhite")!
    static let borderHighlight = UIColor(named: "borderHighlight")!
    static let blackOverlay = UIColor(named: "blackOverlay")!
    static let opaqueBackground = UIColor(named: "opaqueBackground")!
    static let opaqueLight = UIColor(named: "opaqueLight")!
    static let opaqueWhite = UIColor(named: "opaqueWhite")!
}

