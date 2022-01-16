//
//  SwiftUIViewModifiers.swift
//  VK App
//
//  Created by Lewis on 01.12.2021.
//

import SwiftUI

struct CircleShadow: ViewModifier {
    let shadowColor: Color
    let shadowRadius: CGFloat
    let imageRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(imageRadius)
            .overlay(RoundedRectangle(cornerRadius: 50)
            .stroke(Color(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0), lineWidth: 1))
            .background(Circle()
                .fill(Color.white)
                .shadow(color: shadowColor, radius: shadowRadius))
    }
}
