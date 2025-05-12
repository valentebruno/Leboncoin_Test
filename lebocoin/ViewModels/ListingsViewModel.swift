//  ContentView.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.
import Foundation
import Combine

class ListingsViewModel: ObservableObject {
    @Published var listings: [ListingItem] = []
    @Published var categories: [CategoryItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService

    // A dictionary to quickly find category name by ID
    private var categoryMap: [Int: String] = [:]

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    func fetchAllData() {
        isLoading = true
        errorMessage = nil
        
        let listingsPublisher = Future<[ListingItem], APIError> { promise in
            self.apiService.fetchListings(completion: promise)
        }
        
        let categoriesPublisher = Future<[CategoryItem], APIError> { promise in
            self.apiService.fetchCategories(completion: promise)
        }
        
        Publishers.Zip(listingsPublisher, categoriesPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    // More specific error handling can be done here based on APIError type
                    print("Error fetching data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (listings, categories) in
                guard let self = self else { return }
                self.listings = listings.sorted(by: { $0.creationDate > $1.creationDate }).sorted(by: { $0.isUrgent && !$1.isUrgent })
                self.categories = categories
                self.buildCategoryMap()
            })
            .store(in: &cancellables)
    }

    private func buildCategoryMap() {
        var map: [Int: String] = [:]
        for category in categories {
            map[category.id] = category.name
        }
        self.categoryMap = map
    }

    func categoryName(for categoryId: Int) -> String? {
        return categoryMap[categoryId]
    }
}
