//
//  HomePageViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/27/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController, CAAnimationDelegate {
    
    var currentUser: User?

    let locationManager = CoreLocationController.shared.locationManager
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let color1 = #colorLiteral(red: 0.1176470588, green: 0.262745098, blue: 0.5137254902, alpha: 1).cgColor
    let color2 = #colorLiteral(red: 0.1137254902, green: 0.137254902, blue: 0.1568627451, alpha: 1).cgColor
    let color3 = #colorLiteral(red: 0, green: 0.05098039216, blue: 0.1725490196, alpha: 1).cgColor
    
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createBarCrawlButton: BarCrawlButton!
    @IBOutlet weak var myCrawlsButton: BarCrawlButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //Side View
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var LargeProPicImageView: UIImageView!
    @IBOutlet weak var usernameSideLabel: UILabel!
    @IBOutlet weak var emailSideLabel: UILabel!
    @IBOutlet weak var backButtonSideView: BarCrawlButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        locationManager.delegate = self
        CoreLocationController.shared.activateLocationServices()
        createGradientView()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.sideMenuView.transform = CGAffineTransform(scaleX: -1.3, y: 1.3)
            UIView.animate(withDuration: 0.2, animations: {
                self.sideMenuView.alpha = 1
                self.createBarCrawlButton.isEnabled = false
                self.myCrawlsButton.isEnabled = false
                self.sideMenuView.transform = CGAffineTransform.identity
            })
        }
    }
    
    @IBAction func backButtonSideViewTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.sideMenuView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.2, animations: {
                self.sideMenuView.alpha = 0
                self.createBarCrawlButton.isEnabled = true
                self.myCrawlsButton.isEnabled = true
                self.sideMenuView.transform = CGAffineTransform(scaleX: -1.3, y: 1.3)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientView()
    }
    
    func createGradientView() {
        gradientSet.append([color1, color2])
        gradientSet.append([color2, color3])
        gradientSet.append([color3, color1])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.drawsAsynchronously = true
        self.view.layer.insertSublayer(gradient, at: 0)
        animateGradient()
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    

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
}

extension HomePageViewController {
    func setUpUI() {
        let greyBorder = #colorLiteral(red: 0.1137254902, green: 0.137254902, blue: 0.1568627451, alpha: 1).cgColor
        self.view.backgroundColor = .mainBackground
        welcomeLabel.textColor = .lightBlue
        usernameLabel.textColor = .lightBlue
        guard let user = UserController.shared.currentUser else {return}
        usernameSideLabel.text = user.username
        emailSideLabel.text = user.email
        usernameLabel.text = "\(user.username)"
        proPicImageView.image = user.proPic
        proPicImageView.layer.cornerRadius = 40
        proPicImageView.clipsToBounds = true
        proPicImageView.layer.borderColor = greyBorder
        proPicImageView.layer.borderWidth = 3
        proPicImageView.contentMode = .scaleAspectFill
        LargeProPicImageView.image = user.proPic
        LargeProPicImageView.layer.cornerRadius = 120
        LargeProPicImageView.clipsToBounds = true
        LargeProPicImageView.layer.borderColor = greyBorder
        LargeProPicImageView.layer.borderWidth = 3
        LargeProPicImageView.contentMode = .scaleAspectFill
        sideMenuView.alpha = 0
    }
}
