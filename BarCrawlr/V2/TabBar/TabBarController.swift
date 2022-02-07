//
//  TabBarController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 2/6/22.
//  Copyright © 2022 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

@available(iOS 13.0, *)
final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accountView = UIHostingController(rootView: AccountView())
        let homeView = HomeViewController()
        accountView.tabBarItem = UITabBarItem(title: "Account", image: nil, tag: 0)
        homeView.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 1)
        
        tabBarController?.selectedIndex = 0
        setViewControllers([homeView, accountView], animated: true)
    }
}
