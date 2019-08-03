//
//  NameBarCrawlViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/31/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class NameBarCrawlViewController: UIViewController {
    
    @IBOutlet weak var crawlNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var crawlDatePicker: UIDatePicker!
    
    var barCrawlCreated: BarCrawl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
