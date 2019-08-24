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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    //CLLocation Manager
    let locationManager = CoreLocationController.shared.locationManager
    var currentLocation: CLLocationManager {
        return CoreLocationController.shared.locationManager
    }
    
    //Sources of Truth
    var barCrawl: BarCrawl?
    var barItems: [Bars] = []
    var url: String?
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        activateButton()
        hideDetailView()
        listOfBarsTableView.isEditing = true
        locationManager.delegate = self
        listOfBarsTableView.delegate = self
        listOfBarsTableView.dataSource = self
        mapView.delegate = self
        listOfBarsTableView.estimatedRowHeight = UITableView.automaticDimension
        CoreLocationController.shared.activateLocationServices()
        getMyRegion()
        findBarsFromCurrentLocation(searchTerm: "Bar")
        self.hideKeyboardWhenTappedAround()
    }
    
    func getMyRegion() {
        DispatchQueue.main.async {
            guard let latitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude, let longitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude else {return}
            let userCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mySpan = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
            let myRegion = MKCoordinateRegion(center: userCoordinates, span: mySpan)
            self.mapView.setRegion(myRegion, animated: true)
        }
    }
    
    func setYelpReviewImage(barRating: Float) {
        switch barRating {
        case 0.0:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_0")
        case 1.0:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_1")
        case 1.5:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_1_half")
        case 2.0:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_2")
        case 2.5:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_2_half")
        case 3.0:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_3")
        case 3.5:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_3_half")
        case 4.0:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_4")
        case 4.5:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_4_half")
        case 5.0:
            self.starRatingImage.image = #imageLiteral(resourceName: "small_5")
        default:
            self.starRatingImage.alpha = 0
        }
    }
    
    override func loadView() {
        super.loadView()
        addAllSubviews()
        constrainView()
        setUpStackViews()
        setUpRatingStackView()
        setUpZipCodeStackView()
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let currentBarCrawl = barCrawl else {return}
        DispatchQueue.main.async {
            self.presentBarCrawlVC(barCrawl: currentBarCrawl)
        }
    }
    
    
    func createAnnotations(barsInCrawl: [Bar]) {
        mapView.removeAnnotations(mapView.annotations)
        guard let barsInBarCrawl = barCrawl?.bars else {return}
        for bars in barsInBarCrawl {
            let annotations = customPin(coordinate: CLLocationCoordinate2D(latitude: bars.latitude, longitude: bars.longitude), title: bars.name, subtitle: bars.address)
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let viewRegion = MKCoordinateRegion(center: annotations.coordinate, span: span)
            mapView.setRegion(viewRegion, animated: true)
            mapView.addAnnotation(annotations)
        }
    }
    
    //Adding the subviews
    func addAllSubviews() {
        self.view.addSubview(barDetailView)
        self.view.addSubview(labelStackView)
        self.view.addSubview(ratingStackView)
        self.view.addSubview(nameDetailLabel)
        self.view.addSubview(addressDetailLabel)
        self.view.addSubview(cityAndStateDetailLabel)
        self.view.addSubview(zipCodeDetailLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(barImage)
        self.view.addSubview(visualEffectView)
        self.view.addSubview(yelpButton)
        self.view.addSubview(zipCodeStackView)
        
    }
    
    //Setup the stackviews
    func setUpStackViews() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(barImage)
        labelStackView.addArrangedSubview(zipCodeStackView)
        labelStackView.addArrangedSubview(ratingStackView)
        labelStackView.addArrangedSubview(addressDetailLabel)
        labelStackView.addArrangedSubview(cityAndStateDetailLabel)
        labelStackView.addArrangedSubview(zipCodeDetailLabel)
        labelStackView.addArrangedSubview(closeButton)
    }
    
    func setUpRatingStackView() {
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.addArrangedSubview(starRatingImage)
        ratingStackView.addArrangedSubview(ratingDetailLabel)
    }
    
    func setUpZipCodeStackView() {
        zipCodeStackView.translatesAutoresizingMaskIntoConstraints = false
        zipCodeStackView.addArrangedSubview(nameDetailLabel)
        zipCodeStackView.addArrangedSubview(yelpButton)
    }
    
    func barDetailPopUp() {
        barDetailView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        labelStackView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.2) {
            self.visualEffectView.alpha = 1
            self.barDetailView.alpha = 1
            self.labelStackView.alpha = 1
            self.barDetailView.transform = CGAffineTransform.identity
            self.labelStackView.transform = CGAffineTransform.identity
        }
    }
    
    func closePopUp() {
        UIView.animate(withDuration: 0.1) {
            self.barDetailView.alpha = 0
            self.labelStackView.alpha = 0
        }
    }
    
    //Creating safeArea
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    //MARK: - Initializing custom views
    
    //Detail View
    let barDetailView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .mainBackground
        return view
    }()
    
    //Visual Effect View
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = true
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
    
    let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.contentMode = .left
        stackView.spacing = 0
        return stackView
    }()
    
    let zipCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.contentMode = .left
        stackView.spacing = 0
        return stackView
    }()
    
    //ImageView
    let barImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 7
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let starRatingImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.contentMode = .left
        return image
    }()
    
    //Labels
    let nameDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.textColor = .lightBlue
        label.font = label.font.withSize(24)
        return label
    }()
    
    let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.textAlignment = .left
        label.textColor = .offWhite
        return label
    }()
    
    let cityAndStateDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "City and State"
        label.textAlignment = .left
        label.textColor = .offWhite
        return label
    }()
    
    let zipCodeDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Zip"
        label.textAlignment = .left
        label.textColor = .offWhite
        return label
    }()
    
    let ratingDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.textAlignment = .left
        label.contentMode = .left
        label.font = label.font.withSize(12)
        label.textColor = .offWhite
        return label
    }()
    
    //Buttons
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .lightBlue
        button.cornerRadius(8)
        button.setTitleColor(.mainBackground, for: .normal)
        button.tintColor = .mainBackground
        return button
    }()
    
    let yelpButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "yelpLogo"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        return button
    }()
    
    
    
    //Button actions - detail view
    @objc func buttonTapped(sender: UIButton) {
        switch sender {
        case closeButton:
            selectButton(closeButton)
            closePopUp()
        case yelpButton:
            openUrl(urlStr: url)
        default:
            print("Button not found")
        }
    }
    
    func openUrl(urlStr: String!) {
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:]) { (success) in
                if success {
                    print("URL Opened")
                } else {
                    print("couldn't open url")
                }
            }
        }
    }
    
    func activateButton() {
        closeButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        yelpButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
    
    func selectButton(_ button: UIButton) {
        closeButton.setTitleColor(UIColor.lightGray, for: .normal)
        button.setTitleColor(.mainBackground, for: .normal)
    }
    
    //Hide Detail View
    func hideDetailView() {
        barDetailView.alpha = 0
        labelStackView.alpha = 0
        visualEffectView.alpha = 0
    }
    
    func showDetailView() {
        barDetailPopUp()
        barDetailView.addShadow()
        visualEffectView.alpha = 0
    }
    
    //Constrain DetailView
    func constrainView() {
        barDetailView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 80, bottomPadding: -70, leadingPadding: 40, trailingPadding: -40)
        labelStackView.anchor(top: barDetailView.topAnchor, bottom: barDetailView.bottomAnchor, leading: barDetailView.leadingAnchor, trailing: barDetailView.trailingAnchor, topPadding: 10, bottomPadding: -10, leadingPadding: 10, trailingPadding: -10)
        visualEffectView.anchor(top: barDetailView.topAnchor, bottom: barDetailView.bottomAnchor, leading: barDetailView.leadingAnchor, trailing: barDetailView.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
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
            guard let bars = barCrawl?.bars else {return UIView()}
            let titleLabel = UILabel()
            if bars.count == 0 {
                titleLabel.alpha = 0
            } else {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        titleLabel.alpha = 1
                        titleLabel.text = " Bars Selected ▾"
                        titleLabel.backgroundColor = .opaqueLight
                        titleLabel.textColor = .mainBackground
                    }
                }
            }
            return titleLabel
        case 1:
            let titleLabel = UILabel()
            titleLabel.alpha = 1
            titleLabel.text = " Search Results"
            titleLabel.backgroundColor = .opaqueBackground
            titleLabel.textColor = .offWhite
            return titleLabel
        default:
            let titleLabel = UILabel()
            titleLabel.text = "Title"
            titleLabel.backgroundColor = .white
            return titleLabel
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if editingStyle == .delete {
                guard let bar = barCrawl?.bars[indexPath.row], let barCrawl = barCrawl else {return}
                self.barCrawl?.bars.remove(at: indexPath.row)
                BarCrawlController.shared.deleteBar(bar: bar, from: barCrawl) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.createAnnotations(barsInCrawl: barCrawl.bars)
                            self.listOfBarsTableView.reloadData()
                        }
                    } else {
                        print("Failed to delete bar from bar crawl")
                    }
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.section {
        case 0:
            return .delete
        default:
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard var bars = barCrawl?.bars else {return}
        if destinationIndexPath.section != sourceIndexPath.section {
            return
        } else {
            let movedObject = bars[sourceIndexPath.row]
            bars.remove(at: sourceIndexPath.row)
            bars.insert(movedObject, at: destinationIndexPath.row)
            barCrawl?.bars = bars
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath.section == proposedDestinationIndexPath.section ? proposedDestinationIndexPath : sourceIndexPath
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
    
    //Segue function
    func presentBarCrawlVC(barCrawl: BarCrawl) {
        if barCrawl.bars.count >= 2 {
        let storyboard = UIStoryboard(name: "BarCrawlView", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "BarCrawlVC") as? BarCrawlViewController else {return}
        viewController.barCrawlLandingPad = barCrawl
        self.present(viewController, animated: true)
        } else {
                self.warningLabel.alpha = 1
            UIView.animate(withDuration: 7) {
                self.warningLabel.alpha = 0
            }
        }
    }
    
    func findBarsFromCurrentLocation(searchTerm: String) {
        guard let location = CoreLocationController.shared.locationManager.location?.coordinate else {return}
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

extension CreateBarCrawlViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            CoreLocationController.shared.activateLocationServices()
        }
    }
}

extension CreateBarCrawlViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm != "" else {return}
        findBarsFromCurrentLocation(searchTerm: searchTerm)
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
            let rating = cell.barCell?.rating,
            let reviewCount = cell.barCell?.reviewCount,
            let yelpurl = cell.barCell?.url else {return}
        setYelpReviewImage(barRating: rating)
        nameDetailLabel.text = cell.barCell?.name
        addressDetailLabel.text = cell.barCell?.address.physicalAddress
        cityAndStateDetailLabel.text = "\(city), \(state)"
        zipCodeDetailLabel.text = cell.barCell?.address.zipCode
        ratingDetailLabel.text = "\(rating) based on \(reviewCount) reviews"
        url = yelpurl
        BarController.shared.fetchBarImage(imageURL: cell.barCell?.imageURL) { (image) in
            DispatchQueue.main.async {
                self.barImage.image = image
            }
        }
        showDetailView()
    }
}

extension CreateBarCrawlViewController: MKMapViewDelegate {
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

extension CreateBarCrawlViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateBarCrawlViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CreateBarCrawlViewController {
    func setUpUI() {
        backButton.backgroundColor = .lightBlue
        backButton.cornerRadius(8)
        backButton.setTitleColor(.mainBackground, for: .normal)
        confirmButton.backgroundColor = .lightBlue
        confirmButton.cornerRadius(8)
        confirmButton.setTitleColor(.mainBackground, for: .normal)
        listOfBarsTableView.backgroundColor = .mainBackground
        warningLabel.alpha = 0
    }
}
