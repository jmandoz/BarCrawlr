//
//  NameBarCrawlViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/31/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class NameBarCrawlViewController: UIViewController {
    
    @IBOutlet weak var crawlNameTextField: BarCrawlTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var crawlDatePicker: UIDatePicker!
    @IBOutlet weak var nameCrawlLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickDateLabel: UILabel!
    @IBOutlet weak var submitButton: BarCrawlButton!
    @IBOutlet weak var backButton: BarCrawlButton!
    
    
    var barCrawlCreated: BarCrawl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let crawlDate = crawlDatePicker.date
        guard let name = crawlNameTextField.text, !name.isEmpty, let description = descriptionTextView.text, !description.isEmpty, let user = UserController.shared.currentUser else {return}
        BarCrawlController.shared.createBarCrawl(withNme: name, description: description, date: crawlDate, user: user) { (barCrawlFromCompletion) in
            if let barCrawl = barCrawlFromCompletion {
                DispatchQueue.main.async {
                    self.presentCreateBarCrawlVC(barCrawl: barCrawl)
                }
            }
        }
    }
    
    // MARK: - Navigation
    func presentCreateBarCrawlVC(barCrawl: BarCrawl) {
        let storyboard = UIStoryboard(name: "CreateBarCrawl", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateCrawlVC") as? CreateBarCrawlViewController else { return }
        viewController.barCrawl = barCrawl
        self.present(viewController, animated: true)
    }
}

extension NameBarCrawlViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NameBarCrawlViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NameBarCrawlViewController {
    func setUpUI() {
        self.view.backgroundColor = .mainBackground
        crawlDatePicker.backgroundColor = .mainBackground
        crawlDatePicker.setValue(UIColor.white, forKey: "textColor")
        descriptionTextView.backgroundColor = .gray
        descriptionTextView.textColor = .offWhite
        descriptionTextView.cornerRadius(8)
        nameCrawlLabel.textColor = .lightBlue
        descriptionLabel.textColor = .lightBlue
        pickDateLabel.textColor = .lightBlue
        crawlDatePicker.minimumDate = Date()
    }
}
