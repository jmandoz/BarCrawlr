//
//  UserLoginController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/26/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    static let shared = CloudKitController()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //CRUD
    
    //Create
    func save(record: CKRecord, database: CKDatabase, completion: @escaping (CKRecord?) -> Void) {
        database.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
            }
            completion(record)
        }
    }
    
    //Read
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : print("available")
                case .restricted : print("restricted")
                case .noAccount : print("No Account Exists")
                case .couldNotDetermine : print("Account could not be determined")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserReferenceID, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let referenceID = appleUserReferenceID else {completion(nil); return}
            let appleUserReference = CKRecord.Reference(recordID: referenceID, action: .deleteSelf)
            completion(appleUserReference)
        }
    }
    
    func fetchSingleRecord(ofType type: String, withPredicate predicate: NSPredicate, database: CKDatabase, completion: @escaping ([CKRecord]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: type, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
            }
            guard let record = record else {completion(nil); return}
            completion(record)
        }
    }
    
    //Delete
    func delete(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            completion(true)
        }
    }
}
