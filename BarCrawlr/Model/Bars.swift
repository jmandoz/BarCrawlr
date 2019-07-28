//
//  Bars.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/27/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CoreLocation

struct Bars: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case isOpen
        case phone = "display_phone"
        case rating
        case coordinates
        case address
    }
    
    let name: String
    let imageURL: String
    let isOpen: Bool
    let phone: String
    let rating: Float
    let coordinates: [Coordinates]
    let address: [Address]
    
}

struct Coordinates: Codable {
    let longitude: Double
    let latitude: Double
}

struct Address: Codable {
    
    private enum CodingKeys: String, CodingKey{
        case address1
        case city
        case zipCode = "zip_code"
    }
    let address1: String
    let city: String
    let zipCode: String
}
