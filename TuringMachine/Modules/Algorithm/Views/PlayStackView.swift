//
//  PlayStackView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct PlayStackView: View {

    @ObservedObject var vm: PlayingLogic
    @ObservedObject var algorithm: CDAlgorithm

    @State private var isPlaying = false
    @State private var isPlayOptionOn = false

    init(algorithm: CDAlgorithm) {
        self.algorithm = algorithm
        self.vm = .init(algorithm: algorithm)
    }

    var body: some View {
        ZStack {
            ZStack {
                playButton
                    .offset(y: isPlayOptionOn ? -180 : 0)
                stepButton
                    .offset(y: isPlayOptionOn ? -120 : 0)
                resetButton
                    .offset(y: isPlayOptionOn ? -60 : 0)
            }.opacity(isPlayOptionOn ? 1 : 0)
            sectionButton
        }
        .alignHorizontally(.trailing)
        .alignVertically(.bottom)
        .padding(30)
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return PlayStackView(algorithm: algorithm)
}

extension PlayStackView {

    private var playButton: some View {
        Button {
            withAnimation {
                isPlaying.toggle()
                vm.startAutoSteps()
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .makeCircly()
        }.buttonStyle(.plain)
    }

    private var sectionButton: some View {
        Button {
            withAnimation(.bouncy) {
                isPlayOptionOn.toggle()
            }
        } label: {
            Image(systemName: "chevron.up")
                .makeCircly(foreground: .primary, background: .secondaryBackground)
                .rotationEffect(.degrees(isPlayOptionOn ? -180 : 0))
        }.buttonStyle(.plain)
    }

    private var stepButton: some View {
        Button {
            vm.makeStep()
        } label: {
            Image(systemName: "forward.frame.fill")
                .makeCircly()
        }.buttonStyle(.plain)
            .disabled(isPlaying)
            .opacity(isPlaying ? 0.6 : 1)
    }

    private var resetButton: some View {
        Button {
            vm.reset()
        } label: {
            Image(systemName: "stop.fill")
                .makeCircly(background: .red)
        }.buttonStyle(.plain)
            .disabled(isPlaying)
            .opacity(isPlaying ? 0.6 : 1)
    }
}
