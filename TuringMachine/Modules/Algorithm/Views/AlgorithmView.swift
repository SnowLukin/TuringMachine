//
//  AlgorithmView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct AlgorithmView: View {

    @ObservedObject var algorithm: CDAlgorithm

    @State private var showSettings = false
    @State private var showInfo = false
    @State private var showExport = false

    var body: some View {
        ScrollView {
            ZStack {
                Color.secondaryBackground
                VStack(spacing: 0) {
                    ConfigurationsView(algorithm: algorithm, isOpened: $showSettings)
                        .disabled(algorithm.isChanged)
                    ZStack {
                        Color.secondaryBackground
                        VStack {
                            needResetTag
                            TapesWorkView(algorithm: algorithm)
                                .shadow(radius: 1)
                                .disabled(algorithm.isChanged)
                        }
                        .background(Color.systemBackground)
                        .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            PlayStackView(algorithm: algorithm)
                .padding(.bottom)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(algorithm.name.unwrapped)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                toolbarButtons
            }
        }
        .fullScreenCover(isPresented: $showInfo) {
            AlgorithmInfoView(algorithm: algorithm)
        }
        .onChange(of: algorithm.isChanged) { _ in
            // Close the setting if user started algorithm and setting are opened
            if algorithm.isChanged && showSettings {
                withAnimation {
                    showSettings = false
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
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
            }.disabled(algorithm.isChanged)

            Button {
                showInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
            }.disabled(algorithm.isChanged)
        }
    }

    private var needResetTag: some View {
        Text("Reset to enable configurations")
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(height: algorithm.isChanged ? 30 : 0)
            .background(
                .red,
                in: .rect(
                    cornerRadii: .init(
                        topLeading: 8,
                        bottomLeading: 10
                    )
                )
            )
            .alignHorizontally(.trailing)
            .offset(x: algorithm.isChanged ? 0 : 300)
            .opacity(algorithm.isChanged ? 1 : 0)
    }
}
