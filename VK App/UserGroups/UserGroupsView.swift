//
//  UserGroupsView.swift
//  VK App
//
//  Created by Lewis on 01.12.2021.
//

import SwiftUI

struct UserGroupsView: View {
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Group Name")
                    Spacer()
                    Image("noImage")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .modifier(CircleShadow(shadowColor: .black, shadowRadius: 3, imageRadius: 50))
                }
            }
            .navigationBarTitle(Text("Groups"))
        }
    }
}

struct UserGroupsView_Provider: PreviewProvider {
    static var previews: some View {
        UserGroupsView()
    }
}
