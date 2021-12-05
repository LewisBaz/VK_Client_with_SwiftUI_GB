//
//  UserFriendsView.swift
//  VK App
//
//  Created by Lewis on 01.12.2021.
//
import SwiftUI

struct UserFriendsView: View {
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("User Name")
                    Spacer()
                    Image("noImage")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .modifier(CircleShadow(shadowColor: .black, shadowRadius: 3, imageRadius: 50))
                }
            }
            .navigationBarTitle(Text("Friends"))
        }
    }
}

struct UserFriendsView_Provider: PreviewProvider {
    static var previews: some View {
        UserFriendsView()
    }
}
