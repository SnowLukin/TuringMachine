//
//  NewFolderButton.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct NewFolderButton: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var vm = FoldersViewModel()
    @State private var showNewFolderAlert = false

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
            TextFieldAlert(placeholder: "Folder name") { folderName in
                vm.saveFolder(with: folderName, in: context)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.context
    return FolderListView()
        .environment(\.managedObjectContext, context)
}
