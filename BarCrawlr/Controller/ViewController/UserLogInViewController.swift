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
                DispatchQueue.main.async {
                    self.presentHomeView()
                }
            }
        }
    }

    @IBAction func logInButtonTapped(_ sender: Any) {
        CloudKitController.shared.checkForiCloudUser()
    }

    func presentHomeView() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        self.present(viewController, animated: true)
    }
}
