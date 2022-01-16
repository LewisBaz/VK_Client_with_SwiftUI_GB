//
//  MainTabView.swift
//  VK App
//
//  Created by Lewis on 04.12.2021.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var shouldPushNextView: Bool = false
    private let networkService = NetworkService()
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    UserFriendsView(users: UsersViewModel(networkService: networkService))
                        .navigationBarTitle(Text("Friends"))
                }
            }
            .tabItem {
                Label("Friends", systemImage: "person.2.fill")
            }
            
            NavigationView {
                VStack {
                    UserGroupsView(groups: GroupsViewModel(networkService: networkService))
                        .navigationBarTitle(Text("Groups"))
                }
            }
            .tabItem {
                Label("Groups", systemImage: "square.grid.2x2.fill")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
