import SwiftUI

struct Category: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct Ad: Identifiable, Decodable {
    let id: Int
    let category_id: Int
    let title: String
    let description: String
    let price: Double
    let images_url: ImagesURL?
    let creation_date: String
    let is_urgent: Bool
    let siret: String?
    struct ImagesURL: Decodable {
        let small: String?
        let thumb: String?
    }
}

struct ContentView: View {
    @State private var categories: [Category] = []
    @State private var ads: [Ad] = []
    @State private var isLoadingCategories = true
    @State private var isLoadingAds = false
    @State private var searchText: String = ""

    private let dataManager = DataManager()
    
    // Add this computed property to fix the "Cannot find 'filteredAds' in scope" error
    var filteredAds: [Ad] {
        if searchText.isEmpty {
            return ads
        } else {
            return ads.filter { ad in
                ad.title.localizedCaseInsensitiveContains(searchText) ||
                ad.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                 HStack {
                    Spacer()
                    Image("topLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 42) // 30% smaller than previous 60
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 32) // Increased space below the logo

                 Text("Categories")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .padding(.bottom, 8)

                 TextField("Search ads...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                // List
                if !searchText.isEmpty {
                    List(filteredAds) { ad in
                        // Break up complex expressions into variables
                        let categoryName = categories.first(where: { $0.id == ad.category_id })?.name ?? "Unknown"
                        let priceText = String(format: "Price: %.2f €", ad.price)
                        NavigationLink(
                            destination: AdDetailView(
                                ad: ad,
                                categoryName: categoryName
                            )
                        ) {
                            HStack(alignment: .top) {
                                AsyncImage(url: URL(string: ad.images_url?.thumb ?? "")) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Color.red.frame(width: 80, height: 80)
                                    } else {
                                        ProgressView().frame(width: 80, height: 80)
                                    }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(ad.title)
                                            .font(.headline)
                                        if ad.is_urgent {
                                            Text("URGENT")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color.red)
                                                .cornerRadius(4)
                                        }
                                    }
                                    Text(categoryName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(priceText)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 16) // Aligns with search bar
                    .refreshable {
                        await fetchAds()
                    }
                } else {
                    List(categories) { category in
                        NavigationLink(
                            destination: AdsListView(category: category, allAds: ads, categories: categories, searchText: searchText),
                            label: {
                                Text(category.name)
                            }
                        )
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 16) // Aligns with search bar
                    .refreshable {
                        await fetchCategories()
                        await fetchAds()
                    }
                }
                Spacer()
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .onAppear {
                Task {
                    await fetchCategories()
                    await fetchAds()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.orange)
    }

    private func fetchCategories() async {
        guard let url = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json") else { return }
        isLoadingCategories = true
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode([Category].self, from: data) {
                await dataManager.updateCategories(decoded)
                DispatchQueue.main.async {
                    self.categories = decoded
                    self.isLoadingCategories = false
                }
            }
        } catch {
            print("Failed to fetch categories: \(error.localizedDescription)")
        }
    }

    private func fetchAds() async {
        guard let url = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json") else { return }
        isLoadingAds = true
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode([Ad].self, from: data) {
                await dataManager.updateAds(decoded)
                DispatchQueue.main.async {
                    self.ads = decoded
                    self.isLoadingAds = false
                }
            }
        } catch {
            print("Failed to fetch ads: \(error.localizedDescription)")
        }
    }
}

// Make sure AdsListView is defined outside of ContentView
struct AdsListView: View {
    let category: Category
    let allAds: [Ad]
    let categories: [Category]
    let searchText: String // Add this line to pass searchText

    var filteredAds: [Ad] {
        if searchText.isEmpty {
            return allAds
                .filter { $0.category_id == category.id }
                .sorted { $0.is_urgent && !$1.is_urgent }
        } else {
            return allAds
                .filter { ad in
                    ad.category_id == category.id &&
                    (ad.title.localizedCaseInsensitiveContains(searchText) ||
                     ad.description.localizedCaseInsensitiveContains(searchText))
                }
                .sorted { $0.is_urgent && !$1.is_urgent }
        }
    }

    var body: some View {
        List(filteredAds) { ad in
            NavigationLink(destination: AdDetailView(ad: ad, categoryName: category.name)) {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: ad.images_url?.thumb ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipped()
                        } else if phase.error != nil {
                            Color.red.frame(width: 80, height: 80)
                        } else {
                            ProgressView().frame(width: 80, height: 80)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(ad.title)
                                .font(.headline)
                            if ad.is_urgent {
                                Text("URGENT")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            }
                        }
                        Text(category.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Price: \(ad.price, specifier: "%.2f") €")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(category.name)
    }
}

struct AdDetailView: View {
    let ad: Ad
    let categoryName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let urlString = ad.images_url?.small, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        } else if phase.error != nil {
                            Color.red.frame(height: 200)
                        } else {
                            ProgressView().frame(height: 200)
                        }
                    }
                }
                 Text(categoryName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Text(ad.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                HStack {
                    if ad.is_urgent {
                        Text("URGENT")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.red)
                            .cornerRadius(4)
                    }
                }
                Text("Price: \(ad.price, specifier: "%.2f") €")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                Text("Description:")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Text(ad.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Text("Created: \(ad.creation_date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                if let siret = ad.siret {
                    Text("SIRET: \(siret)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
        }
        .navigationTitle(ad.title)
        .navigationBarTitleDisplayMode(.inline)
        .transition(.slide)
   }
}

