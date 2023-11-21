//
//  AlgorithmListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct FolderView: View {

    @ObservedObject var folder: Folder

    @Environment(\.managedObjectContext) private var viewContext

//    @StateObject private var importViewModel = ImportAlgorithmViewModel()
    @State private var showImport = false
    @State private var searchedAlgorithm = ""

    private var algorithms: [Algorithm] {
        let algorithms = folder.unwrappedAlgorithms
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
                AlgorithmsView(algorithms: algorithms, folder: folder)
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchedAlgorithm)
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

//        .fileImporter(isPresented: $showImport, allowedContentTypes: [.mtm], allowsMultipleSelection: false) { result in
//            withAnimation {
//                importViewModel.handleImport(result, folder: folder, viewContext: viewContext)
//            }
//        }
        .navigationTitle(folder.name.unwrapped)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let folder = CoreDataFetcher.shared.fetchEntities(
        ofType: Folder.self, 
        withPredicate: nil,
        in: context
    )[0]
    return NavigationView {
        FolderView(folder: folder)
    }.environment(\.managedObjectContext, context)
}

