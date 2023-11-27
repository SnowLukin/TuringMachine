//
//  FolderViewModel.swift
//  TuringMachine
//
//  Created by Snow Lukin on 26.11.2023.
//

import SwiftUI
import CoreData

final class FoldersViewModel: ObservableObject {

    @Published var showNameTakenMessage = false

    func renameFolder(_ folder: CDFolder, with newName: String, in context: NSManagedObjectContext) {
        withFolderNameValidation(newName, in: context) {
            folder.name = newName
            try? folder.save(in: context)
        }
    }

    func saveFolder(with name: String, in context: NSManagedObjectContext) {
        withFolderNameValidation(name, in: context) {
            try? CDFolder.create(name: name, in: context)
        }
    }

    private func withFolderNameValidation(_ name: String, in context: NSManagedObjectContext, completion: () -> Void) {
        if !CDFolder.isValidName(name, in: context) {
            showNameTakenMessage.toggle()
            return
        }
        completion()
    }
}
