//
//  UserDetailView.swift
//  FriendsFace
//
//  Created by Сергей Захаров on 09.04.2026.
//

import SwiftUI
import SwiftData

struct UserDetailView: View {
    let user: User

    private var registeredFormatted: String {
        user.registered.formatted(date: .abbreviated, time: .shortened)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(user.isActive ? "Active" : "Inactive")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(user.isActive ? .green : .red)
                    )
                    .foregroundStyle(.white)
                    .font(.subheadline)

                detailSection(title: "About", value: user.about)

                VStack(alignment: .leading, spacing: 20) {
                    detailRow(title: "Age", value: "\(user.age)")
                    detailRow(title: "Company", value: user.company)
                    detailRow(title: "Email", value: user.email)
                    detailRow(title: "Address", value: user.address)
                    detailRow(title: "Registered", value: registeredFormatted)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Friends")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if user.friends.isEmpty {
                        Text("No friends listed")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(user.friends, id: \.persistentModelID) { friend in
                            Text(friend.name)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.black.opacity(0.08))
                                )
                                .foregroundStyle(.black)
                                .font(.default)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.large)
    }

    private func detailSection(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    let schema = Schema([User.self, Friend.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])
    let user = User(
        id: "1",
        isActive: true,
        name: "Taylor Swift",
        age: 34,
        company: "Acme",
        email: "t@example.com",
        address: "1 Infinite Loop",
        about: "Sample bio text for preview.",
        registered: .now,
        friends: [
            Friend(id: "a", name: "Alex"),
            Friend(id: "b", name: "Blake")
        ]
    )
    user.friends.forEach { $0.user = user }

    return NavigationStack {
        UserDetailView(user: user)
    }
    .modelContainer(container)
}
