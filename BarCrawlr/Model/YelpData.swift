//
//  YelpData.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//


struct TopLevelJSON: Codable {
    let businesses: [Bars]
}

struct Bars: Codable {
    
    let name: String
    let imageURL: String?
    let isOpen: Bool?
    let phone: String?
    let rating: Float
    let coordinates: Coordinates
    let address: Location
    
    private enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case isOpen = "is_closed"
        case phone = "display_phone"
        case rating
        case coordinates
        case address = "location"
    }
}

struct Coordinates: Codable {
    let longitude: Double?
    let latitude: Double?
}

struct Location: Codable {
    let physicalAddress: String?
    let city: String
    let state: String
    let zipCode: String?

    private enum CodingKeys: String, CodingKey{
        case physicalAddress = "address1"
        case city
        case state
        case zipCode = "zip_code"
    }
}
