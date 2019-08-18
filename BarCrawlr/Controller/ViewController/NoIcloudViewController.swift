//
//  NoIcloudViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/11/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class NoIcloudViewController: UIViewController {

    @IBOutlet weak var backButton: BarCrawlButton!
    @IBOutlet weak var noIcloudLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noIcloudLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        checkForiCloudUser()
    }
    
    func presentHomeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateNoIcloudLabel() {
        noIcloudLabel.alpha = 1
        UIView.animate(withDuration: 5) {
            self.noIcloudLabel.alpha = 0
        }
    }
    
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : self.presentHomeView()
                case .restricted : print("restricted")
                case .noAccount :
                    DispatchQueue.main.async {
                        self.animateNoIcloudLabel()
                    }
                case .couldNotDetermine : print("Account could not be determined")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}
