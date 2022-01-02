//
//  UserGroupsView.swift
//  VK App
//
//  Created by Lewis on 01.12.2021.
//

import SwiftUI
import Kingfisher

struct UserGroupsView: View {
    
    @ObservedObject var groups: GroupsViewModel

    init(groups: GroupsViewModel) {
        self.groups = groups
    }
    
    var body: some View {
        UserGroupsRow(groups: groups)
    }
}

struct UserGroupsRow: View {
    
    @ObservedObject var groups: GroupsViewModel
    
    init(groups: GroupsViewModel) {
        self.groups = groups
    }
    
    var body: some View {
        List(groups.groups.sorted(by: { $0.groupName < $1.groupName })) { group in
            HStack {
                Text(group.groupName)
                Spacer()
                KFImage(URL(string: group.image))
                    .resizable()
                    .frame(width: 30, height: 30)
                    .modifier(CircleShadow(shadowColor: .black, shadowRadius: 3, imageRadius: 50))
            }
        }
        .onAppear(perform: { groups.getGroups() })
        .listStyle(InsetGroupedListStyle())
    }
}
//
//struct UserGroupsView_Provider: PreviewProvider {
//    static var previews: some View {
//        UserGroupsView()
//    }
//}
