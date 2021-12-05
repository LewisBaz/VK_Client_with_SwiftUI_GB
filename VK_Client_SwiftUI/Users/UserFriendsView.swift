//
//  UserFriendsView.swift
//  VK App
//
//  Created by Lewis on 01.12.2021.
//
import SwiftUI

struct UserFriendsView: View {
    
    var body: some View {
        UserFriendsRow()
    }
}

struct UserFriendsRow: View {
    
    @State var users = [
        UserModel(image: Image("noImage"), firstName: "Lev", lastname: "Bazhkov"),
        UserModel(image: Image("noImage"), firstName: "Valeriya", lastname: "Sidorova"),
        UserModel(image: Image("noImage"), firstName: "Pashtet", lastname: "The Dog"),
        UserModel(image: Image("noImage"), firstName: "User", lastname: "Arbuzer"),
        UserModel(image: Image("noImage"), firstName: "Ivan", lastname: "Ivanich"),
        UserModel(image: Image("noImage"), firstName: "Roman", lastname: "Romanich"),
        UserModel(image: Image("noImage"), firstName: "San", lastname: "Sanich"),
        UserModel(image: Image("noImage"), firstName: "Victor", lastname: "Deluxe"),
    ]
    
    var body: some View {
        List(users.sorted(by: { $0.lastName < $1.lastName })) { user in
            NavigationLink(destination: FriendsImagesView()) {
                HStack {
                    Text(user.firstName + " " + user.lastName)
                    Spacer()
                    user.image
                        .resizable()
                        .frame(width: 30, height: 30)
                        .modifier(CircleShadow(shadowColor: .black, shadowRadius: 3, imageRadius: 50))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct UserFriendsView_Provider: PreviewProvider {
    static var previews: some View {
        UserFriendsView()
    }
}
