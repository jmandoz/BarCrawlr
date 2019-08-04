//
//  DateExtension.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
