//
//  FolderCellView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct FolderCellView: View {
    
    @Environment(\.managedObjectContext) private var context

    let folder: Folder
    @Binding var showNameTakenMessage: Bool
    let validation: (String) -> Bool

    @State private var showRenameAlert = false
    @State private var newFolderName = ""

    var body: some View {
        NavigationLink {
            FolderView(folder: folder)
        } label: {
            HStack {
                Image(systemName: "folder")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text(folder.name.unwrapped).lineLimit(1)
                Spacer()
                Text("\(folder.unwrappedAlgorithms.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .contextMenu {
            if folder.name.unwrapped != "Algorithms" {
                Button {
                    showRenameAlert.toggle()
                } label: {
                    Label("Rename", systemImage: "pencil")
                }

                Button(role: .destructive, action: deleteFolder) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .alert("Rename Folder", isPresented: $showRenameAlert) {
            TextField(folder.name.unwrapped, text: $newFolderName)
                .foregroundStyle(.black)
            Button("Cancel", role: .cancel) {
                newFolderName.removeAll()
            }
            Button("Save", action: renameFolder)
        }
        .onChange(of: showRenameAlert) { newValue in
            if !newValue { newFolderName.removeAll() }
        }
    }

    private func renameFolder() {
        if !validation(newFolderName) {
            showNameTakenMessage.toggle()
            return
        }
        folder.name = newFolderName
        try? context.save()
    }

    private func deleteFolder() {
        context.delete(folder)
        try? context.save()
    }
}

