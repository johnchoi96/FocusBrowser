//
//  FocusBrowserApp.swift
//  FocusBrowser
//
//  Created by John Choi on 8/17/24.
//

import SwiftUI

@main
struct FocusBrowserApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
