//  ListingsView.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.
import SwiftUI

struct ListingsView: View {
    @StateObject private var viewModel = ListingsViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.listings.isEmpty {
                    ProgressView("Loading listings...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.title)
                        Text(errorMessage)
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.fetchAllData()
                        }
                        .padding()
                    }
                } else if viewModel.listings.isEmpty {
                     Text("No listings found.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.listings) { item in
                            NavigationLink(destination: ListingDetailViewPlaceholder(item: item)) { // Placeholder for detail view
                                ListingRowView(item: item, categoryName: viewModel.categoryName(for: item.categoryId))
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchAllData()
                    }
                }
            }
            .navigationTitle("Ads")
            .onAppear {
                if viewModel.listings.isEmpty { // Fetch only if not already loaded
                    viewModel.fetchAllData()
                }
            }
        }
        .navigationViewStyle(.stack) // Recommended for wider compatibility including iPad
    }
}

// Placeholder for the detail view. We'll implement this later.
struct ListingDetailViewPlaceholder: View {
    let item: ListingItem
    var body: some View {
        Text("Detail for \(item.title)")
            .navigationTitle(item.title)
    }
}

