//
//  HomeViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 2/6/22.
//  Copyright © 2022 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

final class HomeViewController: UIViewController {
    //42.404287745862554, -71.10576074419743
    
    private var mapView: MKMapView = {
        let mv = MKMapView(frame: .zero)
//        mv.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        mv.mapType = .standard
        let location = CLLocationCoordinate2D(latitude: 42.404287745862554, longitude: -71.10576074419743)
        let span = MKCoordinateSpan(latitudeDelta: 0.010, longitudeDelta: 0.010)
        let region = MKCoordinateRegion(center: location, span: span)
        mv.setRegion(region, animated: true)
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.backgroundColor = .green
        setUpView()
    }
    
    fileprivate func setUpView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension HomeViewController: MKMapViewDelegate {
    
}
