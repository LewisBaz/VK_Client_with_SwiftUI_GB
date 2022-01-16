//
//  PropertyWarppers.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 02.01.2022.
//

import Foundation

@propertyWrapper
struct CodingStyle {
    
    private(set) var value: String = ""

    var wrappedValue: String {
        get { return value }
        set { value = newValue.replacingOccurrences(of: " ", with: "_") }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}
