//
//  TuringMachineApp.swift
//  TuringMachine
//
//  Created by Snow Lukin on 30.10.2023.
//

import SwiftUI

@main
struct TuringMachineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
