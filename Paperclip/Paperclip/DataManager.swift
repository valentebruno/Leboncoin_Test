import Foundation

actor DataManager {
    private var categories: [Category] = []
    private var ads: [Ad] = []

    func updateCategories(_ newCategories: [Category]) {
        categories = newCategories
    }

    func updateAds(_ newAds: [Ad]) {
        ads = newAds
    }

    func getCategories() -> [Category] {
        return categories
    }

    func getAds() -> [Ad] {
        return ads
    }
}