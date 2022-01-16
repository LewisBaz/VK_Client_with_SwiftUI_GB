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
                lineSpacing: 10)
        }
        .navigationBarTitle("Images")
        .onAppear(perform: { images.getImages() })
    }
}

struct FriendsImagesItem: View {
    
    let image: ImageModel
    
    init(image: ImageModel) {
        self.image = image
    }
    
    var body: some View {
        KFImage(URL(string: image.sizes.last?.url ?? ""))
            .resizable()
            .scaledToFit()
    }
}

//struct FriendsImagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsImagesView()
//    }
//}

