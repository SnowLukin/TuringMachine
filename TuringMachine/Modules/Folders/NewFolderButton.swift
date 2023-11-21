//
//  NewFolderButton.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct NewFolderButton: View {

    @Binding var showNameTakenMessage: Bool
    let validation: (_ name: String) -> Bool

    @Environment(\.managedObjectContext) private var context
    @State private var showNewFolderAlert = false
    @State private var folderName = ""

    var body: some View {
        Button {
            showNewFolderAlert.toggle()
        } label: {
            Image(systemName: "folder.badge.plus")
                .font(.title2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .alert("New Folder", isPresented: $showNewFolderAlert) {
            TextField("Folder name", text: $folderName)
                .foregroundStyle(.black)
            Button("Cancel", role: .cancel) {
                folderName.removeAll()
            }
            Button("Save", action: saveFolder)
        }
        .onChange(of: showNewFolderAlert) { newValue in
            if !newValue { folderName.removeAll() }
        }
    }

    private func saveFolder() {
        if !validation(folderName) {
            showNameTakenMessage.toggle()
            return
        }
        let folder = Folder(context: context)
        folder.name = folderName
        try? context.save()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return FolderListView()
        .environment(\.managedObjectContext, context)
}

