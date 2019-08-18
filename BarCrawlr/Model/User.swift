//
//  User.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class User {
    //Class Properties
    var username: String
    var email: String
    var barCrawls: [BarCrawl]
    var proPicData: Data?
    var proPic: UIImage? {
        get {
            guard let proPicData = proPicData else {return nil}
            return UIImage(data: proPicData)
        } set {
            proPicData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    //CloudKit Portoperties
    var ckRecordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    //Profile Picture CKAsset Property
    var proPicAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try proPicData?.write(to: fileURL)
            }
            catch {
                print("Error writing to temporary url \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    //Designated Initializer
    init(proPic: UIImage, username: String, email: String, barCrawls: [BarCrawl] = [], ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.email = email
        self.barCrawls = barCrawls
        self.ckRecordID = ckRecordID
        self.appleUserReference = appleUserReference
        self.proPic = proPic
    }
}

//Extension - initializing User from CKRecord
extension User {
    convenience init?(record: CKRecord) {
        guard let username = record[UserConstants.usernameKey] as? String,
        let email = record[UserConstants.emailKey] as? String,
        let appleUserReference = record[UserConstants.appleUserReferenceKey] as? CKRecord.Reference,
        let proPicAsset = record[UserConstants.proPicKey] as? CKAsset else {return nil}
        
        guard let proPicData = try? Data(contentsOf: proPicAsset.fileURL!) else {return nil}
        guard let photo = UIImage(data: proPicData) else {return nil}
        self.init(proPic: photo, username: username, email: email, ckRecordID: record.recordID, appleUserReference: appleUserReference)
    }
}


//Initializing a CKRecord from an existing User 
extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserConstants.typeKey, recordID: user.ckRecordID)
        self.setValue(user.username, forKey: UserConstants.usernameKey)
        self.setValue(user.email, forKey: UserConstants.emailKey)
        self.setValue(user.proPicAsset, forKey: UserConstants.proPicKey)
        self.setValue(user.appleUserReference, forKey: UserConstants.appleUserReferenceKey)
    }
}

//Magic Strings
struct UserConstants {
    static let typeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let emailKey = "email"
    fileprivate static let appleUserReferenceKey = "appleUserReference"
    fileprivate static let proPicKey = "proPic"
}
