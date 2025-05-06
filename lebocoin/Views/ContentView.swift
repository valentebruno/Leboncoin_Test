//  ContentView.swift
//  lebocoin
//  Created by Bruno Valente on 06/05/25.

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    // State for tracking scroll offset and tab bar visibility
    @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var tabBarVisible = true
    
    @State private var searchText = ""
    
    // Category data
    let categories = [
        Category(id: 1, name: "Roupas", iconName: "tshirt"),
        Category(id: 2, name: "Vagas", iconName: "briefcase"),
        Category(id: 3, name: "Imóveis", iconName: "house"),
        Category(id: 4, name: "Eletrônicos", iconName: "desktopcomputer"),
        Category(id: 5, name: "Veículos", iconName: "car"),
        Category(id: 6, name: "Serviços", iconName: "hammer"),
        Category(id: 7, name: "Esportes", iconName: "sportscourt"),
        Category(id: 8, name: "Para Casa", iconName: "house.fill")
    ]
    
    private let tabItems = [
        ("house.fill", "Home"),
        ("star.fill", "Favorites"),
        ("gearshape.fill", "Settings")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content with scrolling behavior
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack {
                        // Leboncoin Logo
                        Image("topLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("O que você está procurando?", text: $searchText)
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
                        
                        // Location selector
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.orange)
                            Text("Toda a França")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                        
                        HStack {
                            Text("Principais categorias")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        
                        // Categories carousel
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(categories) { category in
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white)
                                                .frame(width: 80, height: 80)
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                            
                                            Image(systemName: category.iconName)
                                                .font(.system(size: 30))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        Text(category.name)
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
                                Text("De acordo com o seu último uso")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                            // Item grid (2 items per row)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                // Item 1 - Blue jeans
                                VStack(alignment: .leading) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(systemName: "rectangle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 120)
                                            .foregroundColor(.blue.opacity(0.2))
                                            .cornerRadius(8)
                                        
                                        Button(action: {}) {
                                            Image(systemName: "heart")
                                                .padding(5)
                                                .background(Circle().fill(Color.white))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(8)
                                    }
                                    
                                    Text("Calça Jeans")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                    
                                    Text("R$ 48")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .padding(.bottom, 5)
                                
                                // Item 2 - Leather jacket
                                VStack(alignment: .leading) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(systemName: "rectangle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 120)
                                            .foregroundColor(.brown.opacity(0.2))
                                            .cornerRadius(8)
                                        
                                        Button(action: {}) {
                                            Image(systemName: "heart")
                                                .padding(5)
                                                .background(Circle().fill(Color.white))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(8)
                                    }
                                    
                                    Text("Jaqueta de Couro marrom")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    
                                    Text("R$ 90")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .padding(.bottom, 5)
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
                    
                    // Only update visibility when we have scrolled a meaningful amount
                    if abs(value - previousScrollOffset) > 10 {
                        withAnimation {
                            tabBarVisible = direction == .up
                        }
                    }
                    
                    previousScrollOffset = value
                }
            }
            
            // Custom Tab Bar
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
                    .foregroundColor(selectedTab == index ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Material.regularMaterial)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 8 : 0)
        .offset(y: isVisible ? 0 : 100) // Move off screen when not visible
        .animation(.spring(response: 0.3), value: isVisible)
    }
}

enum ScrollDirection {
    case up, down
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
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
