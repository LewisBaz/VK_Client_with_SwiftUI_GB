//
//  ContainerView.swift
//  VK App
//
//  Created by Lewis on 04.12.2021.
//

import SwiftUI

struct ContainerView: View {
    
    @State private var shouldPushNextView: Bool = false
    @State private var shouldPushNextView2: Bool = false
    
    @State var sheetPresented = true
        
    var body: some View {
        if shouldPushNextView {
            MainTabView()
        } else {
            LoginView(isUserLoggedIn: $shouldPushNextView)
                .sheet(isPresented: $sheetPresented, content: {
                    VKLoginWebView(closeFunction: {
                        sheetPresented = false
                })
            })
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
