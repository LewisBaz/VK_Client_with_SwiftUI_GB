//
//  UserFriendsView.swift
//  VK App
//
//  Created by Lewis on 01.12.2021.
//

import SwiftUI
import Kingfisher

struct UserFriendsView: View {
    
    @ObservedObject var users: UsersViewModel

    init(users: UsersViewModel) {
        self.users = users
    }
    
    var body: some View {
        UserFriendsRow(users: users)
    }
}

struct UserFriendsRow: View {

    @ObservedObject var users: UsersViewModel
    
    init(users: UsersViewModel) {
        self.users = users
    }
    
    var body: some View {
        List(users.users.sorted(by: { $0.lastName < $1.lastName })) { user in
            NavigationLink(destination: FriendsImagesView(images: ImageViewModel(networkService: NetworkService(), ownerId: String(user.id)))) {
                HStack {
                    Text(user.firstName + " " + user.lastName)
                    Spacer()
                    KFImage(URL(string: user.image))
                        .resizable()
                        .frame(width: 30, height: 30)
                        .modifier(CircleShadow(shadowColor: .black, shadowRadius: 3, imageRadius: 50))
                        .modifier(AvatarImageAnimation(scale: 1, intermediateScale: 1.1, duration: 0.7, repeatCount: 1, finalScale: 1))
                }
            }
        }
        .onAppear(perform: { users.getUsers() })
        .listStyle(InsetGroupedListStyle())
    }
}

//struct UserFriendsView_Provider: PreviewProvider {
//    static var previews: some View {
//        UserFriendsView(users: UsersViewModel(user: UserModel(id: 0, image: "", firstName: "", lastName: ""), networkService: NetworkService()))
//    }
//}
