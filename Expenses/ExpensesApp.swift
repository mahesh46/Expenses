//
//  ExpensesApp.swift
//  Expenses
//
//  Created by mahesh lad on 08/05/2024.
//

import SwiftUI

@main
struct ExpensesApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
