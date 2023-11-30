//
//  FolderView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct FolderView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var folder: CDFolder

    @State private var showImport = false
    @State private var showError = false
    @State private var searchedAlgorithm = ""

    var algorithms: [CDAlgorithm] {
        let algorithms = folder.unwrappedAlgorithms.sorted {
            $0.lastEditDate.unwrappedOrNow > $1.lastEditDate.unwrappedOrNow
        }
        if searchedAlgorithm.isEmpty { return algorithms }
        return algorithms.filter { algorithm in
            let name = algorithm.name.unwrapped
            return name.contains(searchedAlgorithm)
        }
    }

    var body: some View {
        ZStack {
            EmptyFolderMessageView()
                .opacity(algorithms.isEmpty ? 1 : 0)

            List {
                ForEach(algorithms) { algorithm in
                    AlgorithmCellView(algorithm: algorithm)
                }
                .onDelete(perform: deleteAlgorithm)
            }
            .searchable(text: $searchedAlgorithm)
        }
        .alert("Error occupied", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("Failed importing algorithm to an app.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showImport.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .overlay(alignment: .bottom) {
            NewAlgorithmButton(folder: folder)
        }
        .navigationTitle(folder.name.unwrapped)
        .fileImporter(
            isPresented: $showImport,
            allowedContentTypes: [.mtms],
            allowsMultipleSelection: false
        ) { result in
            withAnimation {
                do {
                    let helper = AlgorithmImportHelper()
                    try helper.handleImport(result, folder: folder, context: context)
                } catch {
                    showError.toggle()
                }
            }
        }
    }

    func deleteAlgorithm(offsets: IndexSet) {
        let selectedAlgorithms = offsets.map { algorithms[$0] }
        for algorithm in selectedAlgorithms {
            guard let folder = algorithm.folder else { continue }
            try? folder.removeAlgorithm(algorithm, in: context)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let folder = CDFolder.findAll(in: context)[0]
    return NavigationStack {
        FolderView(folder: folder)
    }
}
