//
//  ContentView.swift
//  FriendsFace
//
//  Created by Сергей Захаров on 09.04.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.name) private var users: [User]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(users, id: \.id) { item in
                        NavigationLink {
                            UserDetailView(user: item)
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(item.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                Text(item.isActive ? "Active" : "Inactive")
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(item.isActive ? .green : .red)
                                    )
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                                Text(item.about)
                                    .foregroundStyle(.primary)
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.08))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Friends list")
            .task {
                await loadRemoteUsersOnceIfStoreIsEmpty()
            }
        }
    }

    @MainActor
    private func loadRemoteUsersOnceIfStoreIsEmpty() async {
        do {
            var count = try modelContext.fetchCount(FetchDescriptor<User>())
            if count > 0 { return }

            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode([UserDTO].self, from: data)

            count = try modelContext.fetchCount(FetchDescriptor<User>())
            if count > 0 { return }

            for dto in decoded {
                modelContext.insert(User(dto: dto))
            }
            try modelContext.save()
        } catch {
            print("Invalid data: \(error)")
        }
    }
}

#Preview {
    let schema = Schema([User.self, Friend.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])

    return ContentView()
        .modelContainer(container)
}
