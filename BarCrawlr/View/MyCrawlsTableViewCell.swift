//
//  MyCrawlsTableViewCell.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class MyCrawlsTableViewCell: UITableViewCell {
    
    weak var delegate:  MyCrawlsTableViewCellDelegate?
    
    var barCrawlLanding: BarCrawl? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var guestListButton: BarCrawlButton!
    
    
    func updateViews() {
        guard let barCrawl = barCrawlLanding else {return}
        nameLabel.text = barCrawl.name
        descriptionLabel.text = barCrawl.description
        dateAndTimeLabel.text = "\(barCrawl.crawlDate.formatDate())"
    }
    
    @IBAction func guestListButtonTapped(_ sender: Any) {
        delegate?.inviteGuestsButtonTapped(cell: self)
    }
    
}

protocol MyCrawlsTableViewCellDelegate: class {
    func inviteGuestsButtonTapped(cell: MyCrawlsTableViewCell)
}
