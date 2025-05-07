//
//  PaperclipApp.swift
//  Paperclip
//
//  Created by Bruno Valente on 14/05/25.
//

import SwiftUI

@main
struct PaperclipApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainViewControllerRepresentable()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
    }
}
