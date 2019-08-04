//
//  MyCrawlsViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class MyCrawlsViewController: UIViewController {
    
    
    @IBOutlet weak var myCrawlsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCrawlsTableView.delegate = self
        myCrawlsTableView.dataSource = self
        self.myCrawlsTableView.reloadData()
        // Do any additional setup after loading the view.
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

extension MyCrawlsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userBarCrawls = UserController.shared.currentUser?.barCrawls.count else {return 0}
        return userBarCrawls
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCrawlsCell", for: indexPath) as? MyCrawlsTableViewCell else {return UITableViewCell()}
        guard let user = UserController.shared.currentUser?.barCrawls[indexPath.row] else {return UITableViewCell()}
        
        cell.nameLabel.text = user.name
        cell.descriptionLabel.text = user.description
        cell.numberOfBarsLabel.text = "\(user.bars.count)"
        cell.dateAndTimeLabel.text = "\(user.crawlDate)"
        
        return cell
    }
    
    
}
