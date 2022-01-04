//
//  FriendsImagesView.swift
//  VK App
//
//  Created by Lewis on 05.12.2021.
//

import SwiftUI
import ASCollectionView_SwiftUI
import Kingfisher

struct FriendsImagesView: View {
    
    @ObservedObject var images: ImageViewModel

    init(images: ImageViewModel) {
        self.images = images
    }
    
    var body: some View {
        ASCollectionView(data: images.images) { image, context in
            FriendsImagesItem(image: image)
        }.layout {
            .grid(
                layoutMode: .fixedNumberOfColumns(1),
                itemSpacing: 10,
                lineSpacing: 0)
        }
        .navigationBarTitle("Images")
        .onAppear(perform: { images.getImages() })
    }
}

struct FriendsImagesItem: View {
    
    let image: ImageModel
    @State private var didTap: Bool = false
    @State private var isScaled: Bool = false
    
    init(image: ImageModel) {
        self.image = image
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(URL(string: image.sizes.last?.url ?? ""))
                .resizable()
            .scaledToFit()
            Button(action: {
                didTap.toggle()
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
                .padding(.bottom, 10)
                .foregroundColor(.red)
                .scaleEffect(isScaled ? 1.2 : 1)
        }
    }
}


//struct FriendsImagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsImagesView()
//    }
//}

