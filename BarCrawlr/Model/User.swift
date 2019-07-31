//
//  User.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class User {
    //Class Properties
    var username: String
    var password: String
    var email: String
    var barCrawls: [BarCrawl]
    //CloudKit Portoperties
    var ckRecordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    //Designated Initializer
    init(username: String, password: String, email: String, barCrawls: [BarCrawl] = [], ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.password = password
        self.email = email
        self.barCrawls = barCrawls
        self.ckRecordID = ckRecordID
        self.appleUserReference = appleUserReference
    }
}

//Extension - initializing User from CKRecord
extension User {
    convenience init?(record: CKRecord) {
        guard let username = record[UserConstants.usernameKey] as? String,
        let email = record[UserConstants.emailKey] as? String,
            let password = record[UserConstants.passwordKey] as? String,
            let appleUserReference = record[UserConstants.appleUserReferenceKey] as? CKRecord.Reference else {return nil}
        
        self.init(username: username, password: password, email: email, ckRecordID: record.recordID, appleUserReference: appleUserReference)
    }
}
//Initializing a CKRecord from an existing User 
extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserConstants.typeKey, recordID: user.ckRecordID)
        self.setValue(user.username, forKey: UserConstants.usernameKey)
        self.setValue(user.password, forKey: UserConstants.passwordKey)
        self.setValue(user.email, forKey: UserConstants.emailKey)
        self.setValue(user.appleUserReference, forKey: UserConstants.appleUserReferenceKey)
    }
}

//Magic Strings
struct UserConstants {
    static let typeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let passwordKey = "password"
    fileprivate static let emailKey = "email"
    fileprivate static let appleUserReferenceKey = "appleUserReference"
}
