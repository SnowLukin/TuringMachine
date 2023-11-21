//
//  FolderListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import SwiftUI
import CoreData

struct FolderListView: View {
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Folder.name, ascending: true)
        ],
        animation: .easeInOut)
    private var fetchedFolders: FetchedResults<Folder>

    @State private var showNameTakenMessage = false
    @State private var searchFolder = ""

    private var folders: [Folder] {
        searchFolder.isEmpty
        ? fetchedFolders.map {$0}
        : fetchedFolders.filter { $0.name.unwrapped.contains(searchFolder) }
    }

    var body: some View {
        List(content: foldersView)
        .searchable(text: $searchFolder)
        .alert("Name is taken", isPresented: $showNameTakenMessage) {
            Button("OK", role: .cancel) {}
        }
        .overlay(alignment: .bottom, content: newFolderButton)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationTitle("Folders")
    }

    private func isFolderNameValid(_ name: String) -> Bool {
        name.trimmingCharacters(in: .whitespaces) != "" &&
        !fetchedFolders.contains(where: { $0.name.unwrapped == name })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return NavigationStack {
        FolderListView()
            .environment(\.managedObjectContext, context)
    }
}

extension FolderListView {
    private func foldersView() -> some View {
        FoldersView(
            folders: folders,
            showNameTakenMessage: $showNameTakenMessage,
            validation: isFolderNameValid
        )
    }
    
    private func newFolderButton() -> some View {
        NewFolderButton(
            showNameTakenMessage: $showNameTakenMessage,
            validation: isFolderNameValid
        )
    }
}
