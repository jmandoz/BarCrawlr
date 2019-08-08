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
    
    @IBOutlet weak var signUpButton: BarCrawlButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        UserController.shared.fetchUser { (success) in
            if success {
                DispatchQueue.main.async {
                    self.presentHomeView()
                }
            }
        }
        hideKeyboardWhenTappedAround()
    }

    func presentHomeView() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        self.present(viewController, animated: true)
    }
}

extension UserLogInViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateBarCrawlViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UserLogInViewController {
    func setUpUI() {
        self.view.backgroundColor = UIColor.mainBackground
    }
}
