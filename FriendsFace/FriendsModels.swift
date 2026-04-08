//
//  FriendsModels.swift
//  FriendsFace
//
//  Created by Сергей Захаров on 09.04.2026.
//

import Foundation
import SwiftData

/// Friend rows are not globally unique in the API (same friend `id` can appear for many users),
/// so only `User.id` uses a uniqueness constraint.
@Model
final class Friend {
    var id: String
    var name: String
    var user: User?

    init(id: String, name: String, user: User? = nil) {
        self.id = id
        self.name = name
        self.user = user
    }
}

@Model
final class User {
    @Attribute(.unique) var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    @Relationship(deleteRule: .cascade, inverse: \Friend.user)
    var friends: [Friend]

    init(
        id: String,
        isActive: Bool,
        name: String,
        age: Int,
        company: String,
        email: String,
        address: String,
        about: String,
        registered: Date,
        friends: [Friend] = []
    ) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.friends = friends
    }

    convenience init(dto: UserDTO) {
        self.init(
            id: dto.id,
            isActive: dto.isActive,
            name: dto.name,
            age: dto.age,
            company: dto.company,
            email: dto.email,
            address: dto.address,
            about: dto.about,
            registered: dto.registered,
            friends: []
        )
        self.friends = dto.friends.map { Friend(id: $0.id, name: $0.name, user: self) }
    }
}
