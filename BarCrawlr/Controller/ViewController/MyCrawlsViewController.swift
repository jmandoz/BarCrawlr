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
    
    @IBOutlet weak var homeButton: BarCrawlButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
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
    
    func presentInviteVC(barCrawl: BarCrawl) {
        let storyboard = UIStoryboard(name: "InviteGuests", bundle: nil)
        guard let viewController =  storyboard.instantiateViewController(withIdentifier: "InviteGuestsVC") as? InviteGuestsViewController else {return}
        viewController.barCrawlLanding = barCrawl
        self.present(viewController, animated: true)
    }
}

extension MyCrawlsViewController: UITableViewDelegate, UITableViewDataSource, MyCrawlsTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userCrawls = userBarCrawls.count
        return userCrawls
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let barCrawl = userBarCrawls[indexPath.row]
            self.userBarCrawls.remove(at: indexPath.row)
            BarCrawlController.shared.deleteBarCrawl(barCrawl: barCrawl) { (success) in
                if success {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.myCrawlsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCrawlsCell", for: indexPath) as? MyCrawlsTableViewCell else {return UITableViewCell()}
        let userCrawl = userBarCrawls[indexPath.row]
        cell.barCrawlLanding = userCrawl
        cell.delegate = self
        return cell
    }
    
    func inviteGuestsButtonTapped(cell: MyCrawlsTableViewCell) {
        guard let selectedCrawl = cell.barCrawlLanding else {return}
        presentInviteVC(barCrawl: selectedCrawl)
    }
}

extension MyCrawlsViewController {
    func setUpUI() {
        self.view.backgroundColor = .mainBackground
        myCrawlsTableView.backgroundColor = .mainBackground
    }
}


