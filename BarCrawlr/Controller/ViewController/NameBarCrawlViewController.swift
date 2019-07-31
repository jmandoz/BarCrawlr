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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let crawlDate = crawlDatePicker.date
        guard let name = crawlNameTextField.text, !name.isEmpty, let description = descriptionTextView.text, !description.isEmpty, let user = UserController.shared.currentUser else {return}
        BarCrawlController.shared.createBarCrawl(withNme: name, description: description, date: crawlDate, user: user) { (success) in
            if success != nil {
                
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
