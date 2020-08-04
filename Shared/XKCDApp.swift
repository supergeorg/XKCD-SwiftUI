//
//  XKCDApp.swift
//  Shared
//
//  Created by Georg Meissner on 24.06.20.
//

import SwiftUI

@main
struct XKCDApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, PersistentStore.shared.persistentContainer.viewContext)
        }
    }
}
