//
//  AccountViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 2/6/22.
//  Copyright © 2022 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

@available(iOS 13.0, *)
class AccountViewController: UIViewController {
    let contentView = UIHostingController(rootView: AccountView())
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        view.addSubview(contentView.view)
        setUpConstraints()
    }
    
    fileprivate func setUpConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
