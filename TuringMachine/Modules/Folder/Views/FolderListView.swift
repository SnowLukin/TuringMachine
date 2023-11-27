//
//  FolderListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import SwiftUI
import CoreData

struct FolderListView: View {

    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .forward)])
    private var fetchedFolders: FetchedResults<CDFolder>

    @State private var searchFolder = ""

    @StateObject private var vm = FoldersViewModel()

    var folders: [CDFolder] {
        searchFolder.isEmpty
        ? fetchedFolders.map { $0 }
        : fetchedFolders.filter { $0.name.unwrapped.contains(searchFolder) }
    }

    var body: some View {
        List {
            ForEach(folders) { folder in
                FolderCellView(folder: folder, vm: vm)
            }.onDelete(perform: deleteFolders)
        }
        .searchable(text: $searchFolder)
        .alert("Name is taken", isPresented: $vm.showNameTakenMessage) {
            Button("OK", role: .cancel) {}
        }
        .overlay(alignment: .bottom) {
            NewFolderButton(vm: vm)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationTitle("Folders")
    }

    func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.map { folders[$0] }.forEach {
                try? $0.delete(from: context)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.context
    return NavigationStack {
        FolderListView()
            .environment(\.managedObjectContext, context)
    }
}
