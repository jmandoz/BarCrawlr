//
//  MyCrawlsViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class MyCrawlsViewController: UIViewController {
    
    var userBarCrawls: [BarCrawl] = []
    
    @IBOutlet weak var myCrawlsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCrawlsTableView.delegate = self
        myCrawlsTableView.dataSource = self
        guard let currentUser = UserController.shared.currentUser else {return}
        BarCrawlController.shared.fetchBarCrawls(user: currentUser) { (CrawlsFromCompletion) in
            if let barCrawl = CrawlsFromCompletion {
                self.userBarCrawls = barCrawl
                DispatchQueue.main.async {
                    self.myCrawlsTableView.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBarCrawlVC" {
            guard let index = myCrawlsTableView.indexPathForSelectedRow?.row else {return}
            let destinationVC = segue.destination as? BarCrawlViewController
            let selectedBarCrawl = userBarCrawls[index]
            destinationVC?.barCrawlLandingPad = selectedBarCrawl
        }
    }
}

extension MyCrawlsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userCrawls = userBarCrawls.count
        return userCrawls
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCrawlsCell", for: indexPath) as? MyCrawlsTableViewCell else {return UITableViewCell()}
        let userCrawls = userBarCrawls[indexPath.row]
        cell.nameLabel.text = userCrawls.name
        cell.descriptionLabel.text = userCrawls.description
        cell.dateAndTimeLabel.text = "\(userCrawls.crawlDate.formatDate())"
        return cell
    }
}
