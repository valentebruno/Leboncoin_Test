//  ContentView.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.
//  ContentView.swift
import SwiftUI

struct ContentView: View {
     @State private var selectedTab = 0
    
     @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var tabBarVisible = true // default visible
    
    @State private var searchText = ""
    
     let categories = [
        Category(id: 1, name: "Vêtements", iconName: "tshirt"),
        Category(id: 2, name: "Emplois", iconName: "briefcase"),
        Category(id: 3, name: "Immobilier", iconName: "house"),
        Category(id: 4, name: "Électronique", iconName: "desktopcomputer"),
        Category(id: 5, name: "Véhicules", iconName: "car"),
        Category(id: 6, name: "Services", iconName: "hammer"),
        Category(id: 7, name: "Sports", iconName: "sportscourt"),
        Category(id: 8, name: "Maison", iconName: "house.fill")
    ]
    
    private let tabItems = [
        ("house.fill", "Accueil"),
        ("star.fill", "Favoris"),
        ("gearshape.fill", "Paramètres")]
 
        var body: some View {
        ZStack(alignment: .bottom) {
             ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                         Image("topLogo") // FIXME: need higher res image!
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                         HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Que recherchez-vous ?", text: $searchText)
                                .foregroundColor(.primary)
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                         HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.orange)
                            Text("Toute la France")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                        
                        HStack {
                            Text("Catégories principales")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        
                         ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(categories) { cat in
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white)
                                                .frame(width: 80, height: 80)
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                            
                                            Image(systemName: cat.iconName)
                                                .font(.system(size: 30))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        Text(cat.name)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 80)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                        
                        // Recent items section
                        VStack(spacing: 15) {
                            // Section title with recommendations
                            HStack {
                                Text("D'après votre utilisation récente")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                             let columns = [GridItem(.flexible()), GridItem(.flexible())]
                            LazyVGrid(columns: columns, spacing: 15) {
                                // Item 1 - Blue jeans - this works better with an actual image
                                ItemView(
                                    bgColor: .blue.opacity(0.2),
                                    title: "Jean Bleu",
                                    price: "48 €"
                                )
                                
                                 ItemView(
                                    bgColor: .brown.opacity(0.2),
                                    title: "Veste en Cuir Marron",
                                    price: "90 €"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .background(Color(.systemGroupedBackground))
                    .overlay(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .named("scrollView")).minY
                            )
                        }
                    )
                }
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    // Update tab bar visibility based on scroll direction
                    let direction = value > previousScrollOffset ? ScrollDirection.up : ScrollDirection.down
                    
                     if abs(value - previousScrollOffset) > 10 {
                        withAnimation {
                            tabBarVisible = direction == .up
                        }
                    }
                    
                    previousScrollOffset = value
                }
            }
            
             TabBarView(selectedTab: $selectedTab, tabItems: tabItems, isVisible: $tabBarVisible)
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Int
    let tabItems: [(String, String)]
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabItems.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                    withAnimation {
                        isVisible = true
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabItems[index].0)
                            .font(.system(size: 24))
                        Text(tabItems[index].1)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == index ? .orange : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Material.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.orange, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 8 : 0) // old API but works
        .offset(y: isVisible ? 0 : 100) // Move off screen when not visible
        .animation(.spring(response: 0.3), value: isVisible)
    }
}

 struct ItemView: View {
    var bgColor: Color
    var title: String
    var price: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "rectangle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .foregroundColor(bgColor)
                    .cornerRadius(8)
                
                Button(action: {
                    // Add to favorites - implement later
                    print("Added to favorites")
                }) {
                    Image(systemName: "heart")
                        .padding(5)
                        .background(Circle().fill(Color.white))
                        .foregroundColor(.gray)
                }
                .padding(8)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(price)
                .font(.caption)
                .fontWeight(.bold)
        }
        .padding(.bottom, 5)
    }
}

enum ScrollDirection {
    case up, down
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    // Reduce method required by the protocol
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

 struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
     }
}

 struct Category: Identifiable {
    let id: Int
    let name: String
    let iconName: String
 }
