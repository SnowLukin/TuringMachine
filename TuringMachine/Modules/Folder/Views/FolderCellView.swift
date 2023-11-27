//
//  FolderCellView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct FolderCellView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var folder: CDFolder
    @ObservedObject var vm: FoldersViewModel

    @State private var showRenameAlert = false

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
            Button {
                showRenameAlert.toggle()
            } label: {
                Label("Rename", systemImage: "pencil")
            }

            Button(role: .destructive) {
                deleteFolder(folder)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Rename Folder", isPresented: $showRenameAlert) {
            TextFieldAlert(placeholder: folder.name.unwrapped) { newName in
                vm.renameFolder(folder, with: newName, in: context)
            }
        }
    }

    func deleteFolder(_ folder: CDFolder) {
        try? folder.delete(from: context)
    }
}
