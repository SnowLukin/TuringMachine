//
//  AlgorithmView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct AlgorithmView: View {

    @ObservedObject var algorithm: Algorithm

    @State private var isChanged = false
    @State private var showSettings = false
    @State private var showInfo = false
    @State private var showExport = false

    var body: some View {
        ZStack {
            VStack {
                ConfigurationsView(algorithm: algorithm, showSettings: $showSettings)
                    .disabled(isChanged)
                Text("Reset to enable configurations")
                    .font(.body)
                    .foregroundColor(.red)
                    .opacity(isChanged ? 1 : 0)

                TapesWorkView(algorithm: algorithm)
                    .shadow(radius: 1)
                    .disabled(isChanged)
            }
//            PlayStackView(algorithm: algorithm, isChanged: $isChanged)
        }
        .navigationTitle(algorithm.name.unwrapped)
        .navigationBarBackButtonHidden(isChanged)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                toolbarButtons
            }
        }
        .fullScreenCover(isPresented: $showInfo) {
            AlgorithmInfoView(algorithm: algorithm)
        }
        .onChange(of: isChanged) { newValue in
            withAnimation {
                showSettings = !newValue
            }
        }
//        .fileExporter(
//            isPresented: $showExport,
//            document: DocumentManager(algorithm: viewModel.convertToShared(algorithm)),
//            contentType: .mtm
//        ) { result in
//            switch result {
//            case .success:
//                print("File successfully exported")
//            case .failure:
//                print("Error. Failed exporting the file.")
//            }
//        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CoreDataFetcher.shared.fetchEntities(
        ofType: Algorithm.self,
        withPredicate: nil,
        in: context
    )[0]
    return NavigationStack {
        AlgorithmView(algorithm: algorithm)
    }.environment(\.managedObjectContext, context)
}

extension AlgorithmView {
    private var toolbarButtons: some View {
        Group {
            Button {
                showExport.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }.disabled(isChanged)
            
            Button {
                showInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
            }.disabled(isChanged)
        }
    }
}
