//
//  Bar.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/31/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class Bar {
    //Class Properties
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Float
    //Reference
    weak var barCrawl: BarCrawl?
    //CloudKit Properties
    let recordID: CKRecord.ID
    //BarCrawl Reference
    var barCrawlReference: CKRecord.Reference? {
        guard let barCrawl = barCrawl else {return nil}
        return CKRecord.Reference(recordID: barCrawl.recordID, action: .deleteSelf)
    }
    //Designated Init
    init(name: String, address: String, latitude: Double, longitude: Double, rating: Float, barCrawl: BarCrawl, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.barCrawl = barCrawl
        self.recordID = recordID
    }
    //Initializing the bar object from a record
    convenience init?(record: CKRecord, barCrawl: BarCrawl) {
        guard let name = record[BarConstants.nameKey] as? String,
        let address = record[BarConstants.addressKey] as? String,
        let latitude = record[BarConstants.latitude] as? Double,
        let longitude = record[BarConstants.longitude] as? Double,
        let rating = record[BarConstants.ratingKey] as? Float
            else {return nil}
        self.init(name: name, address: address, latitude: latitude, longitude: longitude, rating: rating, barCrawl: barCrawl, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(bar: Bar) {
        self.init(recordType: BarConstants.typeKey, recordID: bar.recordID)
        self.setValue(bar.name, forKey: BarConstants.nameKey)
        self.setValue(bar.address, forKey: BarConstants.addressKey)
        self.setValue(bar.latitude, forKey: BarConstants.latitude)
        self.setValue(bar.longitude, forKey: BarConstants.longitude)
        self.setValue(bar.rating, forKey: BarConstants.ratingKey)
        self.setValue(bar.barCrawlReference, forKey: BarConstants.barCrawlReferenceKey)
    }
}

struct BarConstants {
    static let typeKey = "Bar"
    static let nameKey = "name"
    static let addressKey = "address"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let ratingKey = "rating"
    static let barCrawlKey = "barCrawl"
    static let barCrawlReferenceKey = "barCrawlReference"
}

extension Bar: Equatable {
    static func == (lhs: Bar, rhs: Bar) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
