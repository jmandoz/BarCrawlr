//
//  BarCrawlViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 8/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import MapKit

class BarCrawlViewController: UIViewController {
    
    var barCrawlLandingPad: BarCrawl?
    
    @IBOutlet weak var barCrawlDateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listOfBarsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfBarsTableView.delegate = self
        listOfBarsTableView.dataSource = self
        mapView.delegate = self
        listOfBarsTableView.reloadData()
        guard let date = barCrawlLandingPad?.crawlDate else {return}
        barCrawlDateLabel.text = "Scheduled for: \(date.formatDate())"
        guard let barsInCrawl = barCrawlLandingPad?.bars else {return}
        DispatchQueue.main.async {
            self.createAnnotations(barsInCrawl: barsInCrawl)
        }
        getDirections()
    }
    
    func createAnnotations(barsInCrawl: [Bar]) {
        guard let barsInBarCrawl = barCrawlLandingPad?.bars else {return}
        for bars in barsInBarCrawl {
            let annotations = MKPointAnnotation()
            annotations.title = bars.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: bars.latitude, longitude: bars.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let viewRegion = MKCoordinateRegion(center: annotations.coordinate, span: span)
            mapView.setRegion(viewRegion, animated: false)
            mapView.addAnnotation(annotations)
        }
    }
    
    func getDirections() {
        var coordinateArray = [CLLocationCoordinate2D]()
        guard let locations = barCrawlLandingPad?.bars else {return}
        for bars in locations {
            let coordinate = CLLocationCoordinate2DMake(bars.latitude, bars.longitude)
            coordinateArray.append(coordinate)
        }
        let myPolyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        mapView.visibleMapRect = myPolyline.boundingMapRect
        guard let firstLocation = coordinateArray.first else {return}
        let request = createDirectionRequest(from: firstLocation)
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

    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        guard let destinationBar = barCrawlLandingPad?.bars.last else {return MKDirections.Request()}
        let barNumberTwo = CLLocationCoordinate2D(latitude: destinationBar.latitude, longitude: destinationBar.longitude)
        let startingLocatin = MKPlacemark(coordinate: coordinate)
        let destinationCoordinate = MKPlacemark(coordinate: barNumberTwo)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocatin)
        request.destination = MKMapItem(placemark: destinationCoordinate)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
        
    }
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

extension BarCrawlViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let barCount = barCrawlLandingPad?.bars.count else {return 0}
        return barCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "barsInCrawlCell", for: indexPath) as? BarCrawlViewTableViewCell else {return UITableViewCell()}
        let bars = barCrawlLandingPad?.bars[indexPath.row]
        cell.barNameLabel.text = bars?.name
        cell.barAddressLabel.text = bars?.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let titleLabel = UILabel()
            titleLabel.text = barCrawlLandingPad?.name
            titleLabel.textColor = UIColor(named: "headerBackground")
            titleLabel.font = UIFont(name: "Helvetica", size: 22.0)
            titleLabel.textAlignment = .center
            titleLabel.backgroundColor = .white
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
        renderer.strokeColor = UIColor(named: "headerBackground")
        return renderer
    }
}
