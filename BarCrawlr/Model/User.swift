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
    //CloudKit Portoperties
    var ckRecordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    //Designated Initializer
    init(username: String, password: String, email: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.password = password
        self.email = email
        self.ckRecordID = ckRecordID
        self.appleUserReference = appleUserReference
    }
    
}
