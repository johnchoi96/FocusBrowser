//
//  ContentView.swift
//  FocusBrowser
//
//  Created by John Choi on 8/17/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            // Sidebar
            List {
                Text("Content coming soon ...")
            }
            .listStyle(SidebarListStyle())

            // Main detail view
            UKBrowserView()
                .navigationTitle("Browser")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
