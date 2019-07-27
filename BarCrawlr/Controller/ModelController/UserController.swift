//
//  UserController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/26/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //Shared Instance
    static let shared = UserController()
    
    //Source of Truth
    var currentUser: User?
    
    //CRUD Functions
    
    //Create
    func createUserWith(userName: String, email: String, password: String, completion: @escaping (User?) -> Void) {
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else {completion(nil); return}
            let newUser = User(username: userName, password: password, email: email, appleUserReference: appleUserReference)
            let userRecord = CKRecord(user: newUser)
            CloudKitController.shared.save(record: userRecord, database: CloudKitController.shared.privateDB){ (record) in
                guard let record = record, let user = User(record: record)
                else {completion(nil); return}
                self.currentUser = user
                completion(user)
            }
        }
    }
    //Read
    func fetchUser(completion: @escaping (Bool) -> Void) {
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else {completion(false); return}
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
            CloudKitController.shared.fetchSingleRecord(ofType: UserConstants.typeKey, withPredicate: predicate, database: CloudKitController.shared.privateDB) { (record) in
                guard let record = record, let firstRecord = record.first else {completion(false);return}
                self.currentUser = User(record: firstRecord)
                completion(true)
            }
        }
    }
    
}
