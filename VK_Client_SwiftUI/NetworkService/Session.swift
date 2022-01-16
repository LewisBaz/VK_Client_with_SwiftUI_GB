//
//  Session.swift
//  VK App
//
//  Created by Lev Bazhkov on 15.06.2021.
//

import UIKit

final class Session {
    
    private init() {}
    
    static let shared = Session()
    
    var token: String = ""
    var userId: String = "0"
}
