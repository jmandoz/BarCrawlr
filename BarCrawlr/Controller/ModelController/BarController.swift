//
//  BarController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/27/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

private let apiKey = "gAa_9Vm0dDzqXeQSal7BbLzryWdwCt-vyW-t7fi2LDRrLb5sFgzUESHDVdZNDUV-mPAoJJxwvHJaC-sD-kATeUIi2h_mBrGA9g9dBOeN9W1IBVhlmNzoTKOcqCQyXXYx"

private var header: [String : String] = ["Authorization" : "Bearer \(apiKey)"]

class BarController {
    
    //Base URL
    static let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")
    
    //Shared Instance
    static let shared = BarController()
    
    //Fetch Restaurant/Bar function
    func fetchBar(searchQuery: String, long: )
    
    
    
}
