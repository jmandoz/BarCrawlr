//
//  BarDetailViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/31/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class BarDetailViewController: UIViewController {
    
    var barLanding: Bars?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bar = barLanding else {return}
        nameLabel.text = bar.name
        addressLabel.text = bar.address.physicalAddress
        cityAndStateLabel.text = "\(bar.address.city), \(bar.address.state)"
        zipCodeLabel.text = bar.address.zipCode
        ratingLabel.text = "\(String(describing: bar.rating))"
        BarController.shared.fetchBarImage(imageURL: barLanding?.imageURL) { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
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
