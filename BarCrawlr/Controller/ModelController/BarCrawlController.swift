//
//  BarCrawlController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/31/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class BarCrawlController {
    
    static let shared = BarCrawlController()
    
    var barCrawl:[BarCrawl] = []
    
    
    //CRUD
    
    //Create
    func createBarCrawl(withNme name: String, description: String, date: Date, user: User, completion: @escaping (BarCrawl?) -> Void) {
        let crawl = BarCrawl(name: name, description: description, crawlDate: date, user: user)
        barCrawl.append(crawl)
        let record = CKRecord(barCrawl: crawl)
        CloudKitController.shared.publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record,
            let barCrawl = BarCrawl(record: record, user: user) else {completion(nil); return}
            completion(barCrawl)
        }
    }
    
    func addBarTo(barCrawl: BarCrawl, name: String, address: String, latitude: Double, longitude: Double, rating: Float, completion: @escaping (Bar?) -> Void) {
        let bar = Bar(name: name, address: address, latitude: latitude, longitude: longitude, rating: rating, barCrawl: barCrawl)
        barCrawl.bars.append(bar)
        let record = CKRecord(bar: bar)
        CloudKitController.shared.publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return}
            let bar = Bar(record: record, barCrawl: barCrawl)
            completion(bar)
        }
    }
    
    //Read
    func fetchBarCrawls(user: User, completion: @escaping ([BarCrawl]?) -> Void){
        let userReference = user.ckRecordID
        let userReferencePredicate = NSPredicate(format: "%K == %@", BarCrawlConstants.userReferenceKey, userReference)
        let barCrawlIDs = user.barCrawls.compactMap({$0.recordID})
        let avoidDupPredicate = NSPredicate(format: "NOT(recordID IN %@)", barCrawlIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userReferencePredicate, avoidDupPredicate])
        let query = CKQuery(recordType: BarCrawlConstants.typeKey, predicate: compoundPredicate)
        CloudKitController.shared.publicDB.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return}
            let barCrawls = record.compactMap{BarCrawl(record: $0, user: user)}
            self.barCrawl = barCrawls
            completion(barCrawls)
        }
    }
    
    func fetchBarsFrom(barCrawl: BarCrawl, completion: @escaping ([Bar]?) -> Void) {
        let barCrawlReference = barCrawl.recordID
        let barCrawlPredicate = NSPredicate(format: "%K == %@", BarConstants.barCrawlReferenceKey, barCrawlReference)
        let barID = barCrawl.bars.compactMap({$0.recordID})
        let avoidDupPredicate = NSPredicate(format: "NOT(recordID IN %@)", barID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [barCrawlPredicate, avoidDupPredicate])
        let query = CKQuery(recordType: BarConstants.typeKey, predicate: compoundPredicate)
        CloudKitController.shared.publicDB.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return}
            let bars = record.compactMap({Bar(record: $0, barCrawl: barCrawl)})
            completion(bars)
        }
    }
}