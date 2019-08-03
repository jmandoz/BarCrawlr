//
//  CreateBarCrawlViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/28/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CreateBarCrawlViewController: UIViewController {
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfBarsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    
    
    //CLLocation Manager
    let locationManager = CoreLocationController.shared.locationManager
    
    var currentLocation: CLLocationManager {
        return CoreLocationController.shared.locationManager
    }
    
    //Sources of Truth
    var barCrawl: BarCrawl?
    
    var barItems: [Bars] = []
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        activateButton()
        locationManager.delegate = self
        listOfBarsTableView.delegate = self
        listOfBarsTableView.dataSource = self
        listOfBarsTableView.estimatedRowHeight = UITableView.automaticDimension
        CoreLocationController.shared.activateLocationServices()
    }
    
    override func loadView() {
        super.loadView()
        addAllSubviews()
        constrainView()
        setUpStackViews()
    }
    
    
    
    func createAnnotations(barsInCrawl: [Bar]) {
        guard let barsInBarCrawl = barCrawl?.bars else {return}
        for bars in barsInBarCrawl {
            let annotations = MKPointAnnotation()
            annotations.title = bars.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: bars.latitude, longitude: bars.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let viewRegion = MKCoordinateRegion(center: annotations.coordinate, span: span)
            mapView.setRegion(viewRegion, animated: true)
            mapView.addAnnotation(annotations)
        }
    }
    
    //adding the subviews
    func addAllSubviews() {
        self.view.addSubview(barDetailView)
        self.view.addSubview(labelStackView)
        self.view.addSubview(nameDetailLabel)
        self.view.addSubview(addressDetailLabel)
        self.view.addSubview(cityAndStateDetailLabel)
        self.view.addSubview(zipCodeDetailLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(barImage)
        
    }
    
    //setup the stackviews
    func setUpStackViews() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(barImage)
        labelStackView.addArrangedSubview(nameDetailLabel)
        labelStackView.addArrangedSubview(addressDetailLabel)
        labelStackView.addArrangedSubview(cityAndStateDetailLabel)
        labelStackView.addArrangedSubview(zipCodeDetailLabel)
        labelStackView.addArrangedSubview(ratingDetailLabel)
        labelStackView.addArrangedSubview(closeButton)
    }
    
    //Creating safeArea
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    //MARK: - Initializing custom views
    //Detail View
    let barDetailView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    //Label StackView
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 15
        return stackView
    }()
    
    //ImageView
    let barImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //Labels
    let nameDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        return label
    }()
    
    let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.textAlignment = .left
        return label
    }()
    
    let cityAndStateDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "City and State"
        label.textAlignment = .left
        return label
    }()
    
    let zipCodeDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Zip"
        label.textAlignment = .left
        return label
    }()
    
    let ratingDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.textAlignment = .left
        return label
    }()
    
    //Buttons
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    //Button actions - detail view
    @objc func closeButtonTapped(sender: UIButton) {
        selectButton(sender)
        switch sender {
        case closeButton:
            hideDetailView()
        default:
            print("Button not found")
        }
    }
    
    func activateButton() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped(sender:)), for: .touchUpInside)
    }
    
    func selectButton(_ button: UIButton) {
        closeButton.setTitleColor(UIColor.lightGray, for: .normal)
        button.setTitleColor(.blue, for: .normal)
    }
    
    //Hide Detail View
    func hideDetailView() {
        barDetailView.isHidden = true
        labelStackView.isHidden = true
        barImage.isHidden = true
    }
    
    func showDetailView() {
        barDetailView.isHidden = false
        labelStackView.isHidden = false
        barImage.isHidden = false
        barDetailView.addShadow()
    }
    
    
    //Configure the DetailView
    func configureViews() {
        hideDetailView()
        barDetailView.backgroundColor = .white
    }
    
    //Constrain DetailView
    func constrainView() {
        barDetailView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 80, bottomPadding: -70, leadingPadding: 40, trailingPadding: -40)
        labelStackView.anchor(top: barDetailView.topAnchor, bottom: barDetailView.bottomAnchor, leading: barDetailView.leadingAnchor, trailing: barDetailView.trailingAnchor, topPadding: 10, bottomPadding: -10, leadingPadding: 10, trailingPadding: -10)
    }
    
    
    // MARK: - Navigation
}

//TableView DataSource/Delegate Methodes
extension CreateBarCrawlViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let titleLabel = UILabel()
            titleLabel.isHidden = true
            titleLabel.text = "Bars"
            titleLabel.backgroundColor = .white
            return titleLabel
        case 1:
            let titleLabel = UILabel()
            titleLabel.text = "Search Results"
            titleLabel.backgroundColor = .white
            return titleLabel
        default:
            let titleLabel = UILabel()
            titleLabel.text = "Title"
            titleLabel.backgroundColor = .white
            return titleLabel
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let barCrawl = barCrawl else { return 0 }
            return barCrawl.bars.count
        case 1:
            return barItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectedBarsCell", for: indexPath) as? SelectedBarsListTableViewCell else {return UITableViewCell()}
            let bars = barCrawl?.bars[indexPath.row]
            cell.nameLabel.text = bars?.name
            cell.addressLabel.text = bars?.address
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BarSearchCell", for: indexPath) as? BarSearchResultsTableViewCell else {return UITableViewCell()}
            let barItem = barItems[indexPath.row]
            cell.barCell = barItem
            cell.delegate = self
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
        default:
            return UITableViewCell()
        }
    }
}

extension CreateBarCrawlViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            CoreLocationController.shared.activateLocationServices()
        }
    }
}

extension CreateBarCrawlViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text,
            searchTerm != "",
            let location = CoreLocationController.shared.locationManager.location?.coordinate else {return}
        let lat = location.latitude
        let long = location.longitude
        BarController.shared.fetchBarFrom(Search: searchTerm, lat: lat, long: long) { (BarItemsFromCompletion) in
            if let unwrappedBarItems = BarItemsFromCompletion {
                self.barItems = unwrappedBarItems
                DispatchQueue.main.async {
                    self.listOfBarsTableView.reloadData()
                }
            }
        }
    }
}

extension CreateBarCrawlViewController: BarSearchResultsTableViewCellDelegate {
    func addBarButtonTapped(cell: BarSearchResultsTableViewCell) {
        guard let currentBarCrawl = barCrawl,
            let name = cell.barCell?.name,
            let address = cell.barCell?.address.physicalAddress,
            let latitude = cell.barCell?.coordinates.latitude,
            let longitude = cell.barCell?.coordinates.longitude,
            let rating = cell.barCell?.rating
            else {return}
        
        BarCrawlController.shared.addBarTo(barCrawl: currentBarCrawl, name: name, address: address, latitude: latitude, longitude: longitude, rating: rating) { (bar) in
            if bar != nil {
                DispatchQueue.main.async {
                    self.listOfBarsTableView.reloadData()
                    self.createAnnotations(barsInCrawl: currentBarCrawl.bars)
                }
            }
        }
    }
    
    func detailsButtonTapped(cell: BarSearchResultsTableViewCell) {
        guard let city = cell.barCell?.address.city,
            let state = cell.barCell?.address.state,
            let rating = cell.barCell?.rating else {return}
        nameDetailLabel.text = cell.barCell?.name
        addressDetailLabel.text = cell.barCell?.address.physicalAddress
        cityAndStateDetailLabel.text = "\(city), \(state)"
        zipCodeDetailLabel.text = cell.barCell?.address.zipCode
        ratingDetailLabel.text = "Rating: \(rating)"
        BarController.shared.fetchBarImage(imageURL: cell.barCell?.imageURL) { (image) in
            DispatchQueue.main.async {
                self.barImage.image = image
            }
        }
        showDetailView()
    }
}

