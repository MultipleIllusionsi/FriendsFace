//
//  FriendsFaceApp.swift
//  FriendsFace
//
//  Created by Сергей Захаров on 09.04.2026.
//

import SwiftUI
import SwiftData

@main
struct FriendsFaceApp: App {
    private var modelContainer: ModelContainer = {
        let schema = Schema([User.self, Friend.self])
        let configuration = ModelConfiguration()
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
