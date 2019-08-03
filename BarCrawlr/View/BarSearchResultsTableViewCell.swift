//
//  BarSearchResultsTableViewCell.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/28/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class BarSearchResultsTableViewCell: UITableViewCell {
    
    var barCell: Bars?

    weak var delegate: BarSearchResultsTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.addBarButtonTapped(cell: self)
    }
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        delegate?.detailsButtonTapped(cell: self)
    }
}

protocol BarSearchResultsTableViewCellDelegate: class {
    func addBarButtonTapped(cell: BarSearchResultsTableViewCell)
    func detailsButtonTapped(cell: BarSearchResultsTableViewCell)
}
