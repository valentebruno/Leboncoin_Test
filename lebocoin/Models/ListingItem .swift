//  ListingItem.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.

import Foundation

struct ListingItem: Codable, Identifiable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let imagesUrl: ImagesURL
    let creationDate: String // We can parse this to Date later if needed
    let isUrgent: Bool
    let siret: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case description
        case price
        case imagesUrl = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case siret
    }
}

struct ImagesURL: Codable {
    let small: String?
    let thumb: String?
}
