//
//  TuringMachineApp.swift
//  TuringMachine
//
//  Created by Snow Lukin on 30.10.2023.
//

import SwiftUI
import SwiftData

@main
struct TuringMachineApp: App {
    let context = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FolderListView()
            }
        }
        .environment(\.managedObjectContext, context)
    }
}
