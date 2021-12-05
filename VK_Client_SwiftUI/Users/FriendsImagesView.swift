//
//  FriendsImagesView.swift
//  VK App
//
//  Created by Lewis on 05.12.2021.
//

import SwiftUI
import ASCollectionView_SwiftUI

struct FriendsImagesView: View {
    
    @State var images = [
        ImageModel(image: Image("noImage")),
        ImageModel(image: Image("noImage")),
        ImageModel(image: Image("noImage")),
        ImageModel(image: Image("noImage")),
        ImageModel(image: Image("noImage")),
    ]
    
    var body: some View {
        ASCollectionView(data: images) { (image, context) in
            return FriendsImagesItem(image: image)
        }.layout {
            .grid(
                layoutMode: .fixedNumberOfColumns(2),
                itemSpacing: 10,
                lineSpacing: 10)
        }.navigationBarTitle("Images")
    }
}

struct FriendsImagesItem: View {
    
    let image: ImageModel
    
    var body: some View {
        image.image
            .resizable()
    }
}

struct FriendsImagesView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsImagesView()
    }
}

