//  APIService.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.
import Foundation

class APIService {
    
    static let shared = APIService()
    private let listingsURLString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    private let categoriesURLString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    
    private init() {}

    func fetchListings(completion: @escaping (Result<[ListingItem], APIError>) -> Void) {
        guard let url = URL(string: listingsURLString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let listings = try decoder.decode([ListingItem].self, from: data)
                completion(.success(listings))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping (Result<[CategoryItem], APIError>) -> Void) {
        guard let url = URL(string: categoriesURLString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let categories = try decoder.decode([CategoryItem].self, from: data)
                completion(.success(categories))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
