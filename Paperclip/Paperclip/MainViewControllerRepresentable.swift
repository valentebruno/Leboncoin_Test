import SwiftUI

//
//  MainViewControllerRepresentable.swift
//  Paperclip
//
//  Created by Bruno Valente on 14/05/25.
//


struct MainViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return MainViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}