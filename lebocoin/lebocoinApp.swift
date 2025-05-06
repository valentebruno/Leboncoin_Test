//
//  lebocoinApp.swift
//  lebocoin
//
//  Created by Bruno Valente on 06/05/25.
//

import SwiftUI

@main
struct lebocoinApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
