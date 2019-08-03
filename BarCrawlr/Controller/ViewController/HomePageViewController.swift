//
//  HomePageViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/27/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController {

    let locationManager = CoreLocationController.shared.locationManager
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        CoreLocationController.shared.activateLocationServices()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Appeared")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func activateLocationServices() {
        locationManager.startUpdatingLocation()
    }
}

extension HomePageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            CoreLocationController.shared.activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.first
        } else {
            guard let latest = locations.first else {return}
            let distanceInMeters = currentLocation?.distance(from: latest) ?? 0
            print("distaince in meters \(String(describing: distanceInMeters))")
            currentLocation = latest
        }
    }
}
