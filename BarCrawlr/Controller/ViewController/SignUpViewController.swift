//
//  SignUpViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/25/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: BarCrawlTextField!
    @IBOutlet weak var emailTextField: BarCrawlTextField!
    @IBOutlet weak var passwordTextField: BarCrawlTextField!
    @IBOutlet weak var confirmPasswordTextField: BarCrawlTextField!
    @IBOutlet weak var confirmButton: BarCrawlButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let passwordConfirm = confirmPasswordTextField.text, !passwordConfirm.isEmpty else {return}
        if password == passwordConfirm {
            UserController.shared.createUserWith(userName: username, email: email, password: password) { (user) in
                if user != nil {
                    self.presentHomeView()
                }
            }
        } else {
            print("Password did not match")
        }
    }
    
    func presentHomeView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.present(viewController, animated: true)
        }
    }
}

extension SignUpViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateBarCrawlViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SignUpViewController {
    func setUpUI() {
        self.view.backgroundColor = UIColor.mainBackground
    }
}
