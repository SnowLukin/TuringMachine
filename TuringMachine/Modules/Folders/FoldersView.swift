//
//  FoldersView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct FoldersView: View {

    @Environment(\.managedObjectContext) private var context

    let folders: [Folder]
    @Binding var showNameTakenMessage: Bool
    let validation: (String) -> Bool

    var body: some View {
        ForEach(folders) { folder in
            FolderCellView(
                folder: folder,
                showNameTakenMessage: $showNameTakenMessage,
                validation: validation
            )
            .deleteDisabled(folder.name.unwrapped == "Algorithms")
        }.onDelete(perform: deleteFolders)
    }

    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.map { folders[$0] }.forEach(context.delete)
            try? context.save()
        }
    }
}
