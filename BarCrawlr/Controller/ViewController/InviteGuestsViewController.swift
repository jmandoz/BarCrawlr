//
//  InviteGuestsViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class InviteGuestsViewController: UIViewController {
    
    var barCrawlLanding: BarCrawl?
    var usersInvited: [User]? = []

    @IBOutlet weak var inviteTableView: UITableView!
    @IBOutlet weak var addInviteButton: BarCrawlButton!
    @IBOutlet weak var guestListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addGuestButtonTapped(_ sender: Any) {
        
    }
    
}

extension InviteGuestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = usersInvited?.count else {return 0}
        return users
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "invitesCell", for: indexPath) as? InvitesTableViewCell else {return UITableViewCell()}
        guard let user = usersInvited else {return UITableViewCell()}
        let userForCell = user[indexPath.row]
        cell.backgroundColor = .mainBackground
        cell.usernameLabel.text = userForCell.username
        return cell
    }
}

extension InviteGuestsViewController {
    func setUpUI() {
        self.view.backgroundColor = .mainBackground
        guestListTableView.backgroundColor = .mainBackground
    }
}
