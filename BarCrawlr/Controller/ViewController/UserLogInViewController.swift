//
//  UserLogInViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/25/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class UserLogInViewController: UIViewController {
    

    @IBOutlet weak var LogInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.fetchUser { (success) in
            if success {
                self.presentHomeView()
            }
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        CloudKitController.shared.checkForiCloudUser()
    }
    
    func presentHomeView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationVC")
            self.present(homeViewController, animated: true)
        }
    }
}
