# 📱 Leboncoin Ads Browser

A universal iOS app (iPhone & iPad) built in **Swift**.  
Displays a list of ads from [Leboncoin public API](https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json).

- 🛠️ Built with **UIKit + SwiftUI** (hybrid screens)
- 🗂 Categories mapped via [categories.json](https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json)
- 🔥 Image caching with `NSCache`
- ✅ 100% Swift, no 3rd party libraries
- 🧪 Includes unit tests (`AdsListViewModel`)

---

## 🎯 Features

- Browse ads list (image + title + category + price)
- See *urgent* items with a red badge
- Tap to view full ad details (description, date, price, SIRET)
- Smooth scroll with **image caching**
- Pull to refresh ads list
- iPhone & iPad ready (Universal)
- iOS 16+ compatible

---


# Paperclip Documentation

This document provides detailed information about the Paperclip iOS application, its architecture, components, and how to use or modify it.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Key Components](#key-components)
4. [Data Flow](#data-flow)
5. [UI Components](#ui-components)
6. [Adding Features](#adding-features)
7. [Troubleshooting](#troubleshooting)

## Project Overview

Paperclip is an iOS application that displays classified ads organized by categories. It fetches data from remote JSON endpoints and presents it in a user-friendly interface. The app allows users to browse ads by category, search for specific ads, and view detailed information about each ad.

## Architecture

The application uses a hybrid architecture combining SwiftUI and UIKit:

- **UI Layer**: Primarily SwiftUI-based views with UIKit integration
- **Data Layer**: Actor-based data management with async/await pattern
- **Persistence Layer**: Core Data for local storage

### Integration Pattern

The app uses `UIHostingController` to embed SwiftUI views within UIKit. This is implemented in the `MainViewController` class, which serves as the bridge between UIKit and SwiftUI.

## Key Components

### Data Models

1. **Category**
   - Simple model representing ad categories with id and name

2. **Ad**
   - Comprehensive model for classified ads with properties like:
     - id, category_id, title, description
     - price, creation_date, is_urgent
     - images_url (containing small and thumb URLs)
     - siret (optional business identifier)

### Managers

1. **DataManager**
   - Actor-based manager for thread-safe data operations
   - Handles categories and ads collections
   - Provides methods to update and retrieve data

2. **PersistenceController**
   - Manages Core Data stack
   - Provides shared instance and preview instance for SwiftUI previews
   - Handles persistent store loading and error management

### View Controllers

1. **MainViewController**
   - UIKit view controller that hosts the SwiftUI ContentView
   - Sets up constraints and manages the SwiftUI hosting controller

### SwiftUI Views

1. **ContentView**
   - Main view of the application
   - Manages categories and ads data
   - Handles search functionality
   - Displays either categories list or search results

2. **AdsListView**
   - Displays ads for a specific category
   - Filters and sorts ads (urgent first)
   - Provides navigation to ad details

3. **AdDetailView**
   - Shows detailed information about a specific ad
   - Displays images, title, price, description, etc.
   - Highlights urgent ads

## Data Flow

1. The app starts with `PaperclipApp` which initializes the `PersistenceController`
2. `MainViewControllerRepresentable` is used to create a `MainViewController`
3. `MainViewController` hosts the `ContentView`
4. `ContentView` fetches categories and ads data from remote endpoints
5. Data is stored in the `DataManager` for access throughout the app
6. User interactions trigger navigation to different views or filter the displayed data

## UI Components

### Main Screen

- Categories list with search bar
- When searching, displays filtered ads across all categories

### Category Screen

- List of ads within the selected category
- Urgent ads are displayed first
- Each ad shows a thumbnail, title, price, and urgent status if applicable

### Ad Detail Screen

- Full ad information including larger image
- Displays title, category, price, description
- Shows creation date and SIRET if available
- Highlights urgent status

## Adding Features

### Adding a New View

1. Create a new SwiftUI View file
2. Implement the view structure and logic
3. Add navigation to the new view from an existing view

Example:
```swift
struct NewFeatureView: View {
    var body: some View {
        VStack {
            Text("New Feature")
            // Add your UI components here
        }
        .navigationTitle("New Feature")
    }
}

// Then add navigation to this view from another view:
NavigationLink(destination: NewFeatureView()) {
    Text("Go to New Feature")
}
