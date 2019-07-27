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
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : print("available")
                case .restricted : print("restricted")
                case .noAccount : print("No Account Exists")
                case .couldNotDetermine : print("Error finding the account")
                    
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
    
}
