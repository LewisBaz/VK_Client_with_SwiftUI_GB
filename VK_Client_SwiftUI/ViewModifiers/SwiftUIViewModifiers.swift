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

struct AvatarImageAnimation: ViewModifier {
    
    @State var scale: CGFloat
    var intermediateScale: CGFloat
    var duration: CGFloat
    var repeatCount: Int
    var finalScale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: duration)
                let repeated = baseAnimation.repeatCount(repeatCount)
                withAnimation(repeated) {
                    scale = intermediateScale
                }
                scale = 1
            }
    }
}
