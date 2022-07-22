//
//  FocusApp.swift
//  Focus
//
//  Created by Aahish Balimane on 3/4/22.
//

import SwiftUI

@main
struct FocusApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
