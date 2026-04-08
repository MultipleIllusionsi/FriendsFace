//
//  ContentView.swift
//  FriendsFace
//
//  Created by Сергей Захаров on 09.04.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var results = [User]()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(results, id: \.id) { item in
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
                await loadData()
            }
        }
    }
    
    func loadData() async {
        if !results.isEmpty { return }
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            results = try decoder.decode([User].self, from: data)
        } catch {
            print("Invalid data: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
