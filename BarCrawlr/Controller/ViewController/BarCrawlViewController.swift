//
//  BarCrawlViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BarCrawlViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var LabelsStackView: UIStackView!
    @IBOutlet weak var barCrawlDateLabel: UILabel!
    @IBOutlet weak var barCrawlDistanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listOfBarsTableView: UITableView!
    @IBOutlet weak var myCrawlsButton: BarCrawlButton!
    
    //Sources
    var barCrawlLandingPad: BarCrawl?
    var unwrappedBarsFromCrawl: [Bar] = []
    var distance: Double = 0
    var sourceCoordinate = CLLocationCoordinate2D()
    var arriveCoordinate = CLLocationCoordinate2D()
    
    //View
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        listOfBarsTableView.delegate = self
        listOfBarsTableView.dataSource = self
        mapView.delegate = self
        listOfBarsTableView.reloadData()
        guard let unwrappedBarsInCrawl = barCrawlLandingPad?.bars else {return}
        guard let unwrappedCrawl = barCrawlLandingPad else {return}
        getDirections(locations: unwrappedBarsInCrawl)
        loadBarsFromMyCrawls(barCrawl: unwrappedCrawl, bars: unwrappedBarsInCrawl)
    }
    
    func loadBarsFromMyCrawls(barCrawl: BarCrawl, bars: [Bar]) {
        if bars.count == 0 {
            BarCrawlController.shared.fetchBarsFrom(barCrawl: barCrawl) { (barsFromCompletion) in
                if let unwrappedBars = barsFromCompletion {
                    DispatchQueue.main.async {
                        self.createAnnotations(barsInCrawl: unwrappedBars)
                        self.getDirections(locations: unwrappedBars)
                        self.unwrappedBarsFromCrawl = unwrappedBars
                        self.listOfBarsTableView.reloadData()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.createAnnotations(barsInCrawl: bars)
            }
        }
    }
    
    func createAnnotations(barsInCrawl: [Bar]) {
        for (index, bar) in barsInCrawl.enumerated() {
            let annotations = customPin(coordinate: CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude), title: bar.name, subtitle: "Stop number \(index + 1)")
            if index == 0 {
                annotations.subtitle = "First stop"
            }
            
            mapView.addAnnotation(annotations)
        }
    }

    func getDirections(locations: [Bar]) {
        for bars in stride(from: 0, to: locations.count - 1, by: 1) {
            let firstBar = locations[bars]
            let secondBar = locations[bars + 1]
            let firstCoordinate = CLLocationCoordinate2DMake(firstBar.latitude, firstBar.longitude)
            let secondCoordinate = CLLocationCoordinate2DMake(secondBar.latitude, secondBar.longitude)
            let loc1 = CLLocation(latitude: firstBar.latitude, longitude: firstBar.longitude)
            let loc2 = CLLocation(latitude: secondBar.latitude, longitude: secondBar.longitude)
            let distanceFromBar = loc1.distance(from: loc2)
            distance += distanceFromBar
            sourceCoordinate = firstCoordinate
            arriveCoordinate = secondCoordinate
            let request = createDirectionRequest()
            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] (response, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                guard let directionResponse = response else {return}
                let route = directionResponse.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        guard let centerLatitude = locations.first?.latitude, let centerLongitude = locations.first?.longitude else {return}
        let centerCoordinate = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        barCrawlDistanceLabel.text = "\(Int((distance * 0.000621371).rounded())) mi"
    }
    
    func createDirectionRequest() -> MKDirections.Request {
        let startingLocatin = MKPlacemark(coordinate: sourceCoordinate)
        let destinationCoordinate = MKPlacemark(coordinate: arriveCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocatin)
        request.destination = MKMapItem(placemark: destinationCoordinate)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
    
    func zoomIn(latitude: Double, longitude: Double) {
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func zoomOut(latitude: Double, longitude: Double) {
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
}

extension BarCrawlViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if barCrawlLandingPad?.bars.count == 0 {
            let bars = unwrappedBarsFromCrawl
            return bars.count
        } else {
            guard let bars = barCrawlLandingPad?.bars.count else {return 0}
            return bars
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "barsInCrawlCell", for: indexPath) as? BarCrawlViewTableViewCell else {return UITableViewCell()}
        if barCrawlLandingPad?.bars.count == 0 {
            let bar = unwrappedBarsFromCrawl[indexPath.row]
            cell.barNameLabel.text = bar.name
            cell.barAddressLabel.text = bar.address
            return cell
        } else {
            let bar = barCrawlLandingPad?.bars[indexPath.row]
            cell.barNameLabel.text = bar?.name
            cell.barAddressLabel.text = bar?.address
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if barCrawlLandingPad?.bars.count == 0 {
            let bar = unwrappedBarsFromCrawl[indexPath.row]
            let latitude = bar.latitude
            let longitude = bar.longitude
            zoomIn(latitude: latitude, longitude: longitude)
        } else {
            let bar = barCrawlLandingPad?.bars[indexPath.row]
            guard let latitude = bar?.latitude, let longitude = bar?.longitude else {return}
            zoomIn(latitude: latitude, longitude: longitude)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let titleLabel = UILabel()
            titleLabel.text = barCrawlLandingPad?.name
            titleLabel.textColor = .lightBlue
            titleLabel.textAlignment = .center
            titleLabel.backgroundColor = .mainBackground
            return titleLabel
        default:
            let titleLabel = UILabel()
            titleLabel.text = barCrawlLandingPad?.name
            titleLabel.textColor = UIColor(named: "headerBackground")
            titleLabel.backgroundColor = .white
            return titleLabel
        }
    }
}

extension BarCrawlViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .mainBackground
        renderer.fillColor = .lightBlue
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "pin"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        annotationView.canShowCallout = true
        annotationView.image = #imageLiteral(resourceName: "BarCrawlrAnnotation")
        
        return annotationView
    }
}

extension BarCrawlViewController {
    func setUpUI() {
        guard let date = barCrawlLandingPad?.crawlDate else {return}
        barCrawlDateLabel.text = "Scheduled for: \(date.formatDate())"
        listOfBarsTableView.backgroundColor = .mainBackground
        LabelsStackView.backgroundColor = .opaqueWhite
        LabelsStackView.cornerRadius(8)
    }
}


