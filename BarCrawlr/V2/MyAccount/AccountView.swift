//
//  AccountView.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 2/6/22.
//  Copyright © 2022 Jason Mandozzi. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    @available(iOS 13.0.0, *)
    var body: some View {
        UserHeader()
            .padding(10)
        Spacer()
    }
}

struct UserHeader: View {
    @available(iOS 13.0.0, *)
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .padding(8)
                Text("Settings")
                    .padding(8)
                Spacer()
            }
            Spacer()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        AccountView()
    }
}
