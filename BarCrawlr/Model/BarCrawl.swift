//
//  BarCrawl.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/30/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class BarCrawl {
    //Class properties
    var name: String
    var description: String
    var crawlDate: Date
    var bars: [Bar]
    weak var user: User?
    //CloudKit Properties
    var recordID: CKRecord.ID
    //Designated Init for class
    init(name: String, description: String, crawlDate: Date, bars: [Bar] = [], user: User?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.description = description
        self.crawlDate = crawlDate
        self.bars = bars
        self.user = user
        self.recordID = recordID
    }
    //Reference to the User
    var userReference: CKRecord.Reference? {
        guard let user = user else {return nil}
        return CKRecord.Reference(recordID: user.ckRecordID, action: .deleteSelf)
    }
    //failable initializer - initializing the BarCrawl from the Cloud
    convenience init?(record: CKRecord, user: User) {
        guard let name = record[BarCrawlConstants.nameKey] as? String,
        let description = record[BarCrawlConstants.descriptionKey] as? String,
        let crawlDate = record[BarCrawlConstants.crawlDateKey] as? Date
            else {return nil}
        self.init(name: name, description: description, crawlDate: crawlDate, bars: [], user: user, recordID: record.recordID)
    }
}
//initializing a record from a barCrawl
extension CKRecord {
    convenience init(barCrawl: BarCrawl) {
        self.init(recordType: BarCrawlConstants.typeKey, recordID: barCrawl.recordID)
        self.setValue(barCrawl.name, forKey: BarCrawlConstants.nameKey)
        self.setValue(barCrawl.description, forKey: BarCrawlConstants.descriptionKey)
        self.setValue(barCrawl.crawlDate, forKey: BarCrawlConstants.crawlDateKey)
        self.setValue(barCrawl.userReference, forKey:BarCrawlConstants.userReferenceKey)
    }
}
//Magic Strings
struct BarCrawlConstants {
    static let typeKey = "BarCrawl"
    static let nameKey = "name"
    static let descriptionKey = "description"
    static let crawlDateKey = "crawlDate"
    static let barsKey = "bars"
    static let userKey = "user"
    static let userReferenceKey = "userReference"
    
}
