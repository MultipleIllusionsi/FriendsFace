//
//  User.swift
//  FriendsFace
//
//  Created by Сергей Захаров on 09.04.2026.
//

import Foundation

struct User: Codable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let friends: [Friend]
}


struct Friend: Codable {
    let id: String
    let name: String
}
