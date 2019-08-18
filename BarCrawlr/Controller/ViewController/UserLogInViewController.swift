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
    
    @IBOutlet weak var beerIconImage: UIImageView!
    
    @IBOutlet weak var fetchIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        animateLogo()
        animateIndicator()
        UserController.shared.fetchUser { (success) in
            if success {
                DispatchQueue.main.async {
                    self.presentHomeView()
                }
            } else {
                DispatchQueue.main.async {
                    self.fetchIndicator.alpha = 0
                    self.fetchIndicator.stopAnimating()
                    UIView.animate(withDuration: 3, animations: {
                        self.signUpButton.alpha = 1
                    })
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
    
    func animateIndicator() {
        DispatchQueue.main.async {
            self.fetchIndicator.alpha = 1
            self.fetchIndicator.startAnimating()
        }
    }
    
    func animateLogo() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3, animations: {
                self.beerIconImage.alpha = 1
            })
        }
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
        beerIconImage.alpha = 0
        signUpButton.alpha = 0
        fetchIndicator.alpha = 0
    }
}
