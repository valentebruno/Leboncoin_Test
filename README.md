# 📱 Leboncoin Ads Browser

A universal iOS app (iPhone & iPad) built in **Swift**.  
Displays a list of ads from [Leboncoin public API](https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json).

- 🛠️ Built with **UIKit + SwiftUI** (hybrid screens)
- 🗂 Categories mapped via [categories.json](https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json)
- 🔥 Image caching with `NSCache`
- 🔄 Pull to refresh + loading spinners
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

## 🚀 Screenshots

| List Screen (UIKit)        | Detail Screen (SwiftUI)      |
|----------------------------|------------------------------|
| ![List Screen](screenshot1.png) | ![Detail Screen](screenshot2.png) |

---

## 🏗 Architecture

- **MVVM** (Model-View-ViewModel)
- Data models mapped from **Swagger API**
- Clean **single responsibility** classes
- **No external libraries** used (pure Swift)

---

## 🧪 Tests

Run unit tests:

```bash
⌘ + U  (or Product → Test)
