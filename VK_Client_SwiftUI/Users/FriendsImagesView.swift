//
//  FriendsImagesView.swift
//  VK App
//
//  Created by Lewis on 05.12.2021.
//

import SwiftUI
import Kingfisher

struct FriendsImagesView: View {
    
    @ObservedObject var images: ImageViewModel
    
    let columns = [
        GridItem(.fixed(UIScreen.main.bounds.width - 10), spacing: 0, alignment: .center)
    ]

    init(images: ImageViewModel) {
        self.images = images
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 5)  {
                    if let images = images.images {
                        ForEach(images) { image in
                            FriendsImagesItem(image: image, isLiked: image.likes.userLikes == 0 ? false : true)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Images")
        .onAppear(perform: { images.getImages() })
    }
}

struct FriendsImagesItem: View {
    
    let image: ImageModel
    let networkService = NetworkService()
    @State private var didTap: Bool = false
    @State private var isScaled: Bool = false
    @State private var isLiked: Bool
    
    init(image: ImageModel, isLiked: Bool) {
        self.image = image
        self.isLiked = isLiked
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(URL(string: image.sizes.last?.url ?? ""))
                .resizable()
            .scaledToFit()
            Button(action: {
                didTap.toggle()
                if isLiked == false {
                    self.addLike(ownerId: String(image.ownerID), itemId: String(image.id))
                    isLiked = true
                } else {
                    self.removeLike(ownerId: String(image.ownerID), itemId: String(image.id))
                    isLiked = false
                }
                withAnimation(.easeInOut(duration: 0.5).repeatCount(1), {
                    self.isScaled = true
                })
                self.isScaled = false
            }, label: {
                if image.likes.userLikes == 0 {
                    Image(systemName: didTap ? "heart.fill" : "heart")
                    Text(didTap ? "\(image.likes.count + 1)" : "\(image.likes.count)")
                } else {
                    Image(systemName: didTap ? "heart" : "heart.fill")
                    Text(didTap ? "\(image.likes.count - 1)" : "\(image.likes.count)")
                }
            })
                .padding(.bottom, 5)
                .foregroundColor(.red)
                .scaleEffect(isScaled ? 1.2 : 1)
        }
    }
    
    private func addLike(ownerId: String, itemId: String) {
        networkService.addLike(ownerId: ownerId, itemId: itemId)
    }
    private func removeLike(ownerId: String, itemId: String) {
        networkService.removeLike(ownerId: ownerId, itemId: itemId)
    }
}


//struct FriendsImagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsImagesView()
//    }
//}

