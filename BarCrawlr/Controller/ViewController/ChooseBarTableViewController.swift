//
//  ChooseBarTableViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/27/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CoreLocation


class ChooseBarTableViewController: UITableViewController {
    
    let locationManager = CoreLocationController.shared.locationManager
    
    var currentLocation: CLLocationManager {
        return CoreLocationController.shared.locationManager
    }
    
    var barItems: [Bars] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        CoreLocationController.shared.activateLocationServices()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return barItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BarSearchCell", for: indexPath) as? BarSearchResultsTableViewCell else {return UITableViewCell()}
        let barItem = barItems[indexPath.row]
        // Configure the cell...
        cell.nameLabel.text = barItem.name
        cell.phoneNumberLabel.text = barItem.phone
        cell.addressLabel.text = barItem.address.physicalAddress
        cell.cityAndStateLabel.text = "\(String(describing: barItem.address.city)), \(String(describing: barItem.address.state))"
        cell.zipLabel.text = barItem.address.zipCode
        
        BarController.shared.fetchBarImage(imageURL: barItem.imageURL) { (image) in
            DispatchQueue.main.async {
                cell.barImageView.image = image
            }
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBarDetailVC" {
            guard let index = tableView.indexPathForSelectedRow?.row else {return}
            let destinationVC = segue.destination as? BarDetailViewController
            let bar = barItems[index]
            destinationVC?.barLanding = bar
        }
     }
 
    
}

extension ChooseBarTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm != "" else {return}
        guard let location = CoreLocationController.shared.locationManager.location?.coordinate else {return}
        let lat = location.latitude
        let long = location.longitude
        BarController.shared.fetchBarFrom(Search: searchTerm, lat: lat, long: long) { (BarItemsFromCompletion) in
            if let unwrappedBarItems = BarItemsFromCompletion {
                self.barItems = unwrappedBarItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ChooseBarTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            CoreLocationController.shared.activateLocationServices()
        }
    }
}
