//
//  PlayStackView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

final class PlayStackViewModel: ObservableObject {
    
}

struct PlayStackView: View {

    @ObservedObject var algorithm: Algorithm

    @Binding var isChanged: Bool

    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = PlayStackViewModel()
    @State private var isPlaying: Bool = false
    @State private var isPlayOptionOn: Bool = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 10) {
                    if isPlayOptionOn {
                        playButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        makeStepButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        resetButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    }
                    playOptionButton
                }.padding(30)
            }
        }
    }
}

struct PlayStack_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let algorithm = CoreDataFetcher.shared.fetchEntities(
            ofType: Algorithm.self,
            withPredicate: nil,
            in: context
        )[0]
        PlayStackView(algorithm: algorithm, isChanged: .constant(false))
            .environment(\.managedObjectContext, context)
    }
}

extension PlayStackView {

    private var playButton: some View {
        Button {
            withAnimation {
                isChanged = true
                isPlaying.toggle()
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .makeCircly()
        }
    }

    private var playOptionButton: some View {
        Button {
            withAnimation {
                isPlayOptionOn.toggle()
            }
        } label: {
            Image(systemName: "chevron.up")
                .makeCircly(foreground: .white, background: .black)
                .rotationEffect(.degrees(isPlayOptionOn ? -180 : 0))
        }
    }

    private var makeStepButton: some View {
        Button {
            withAnimation {
                isChanged = true
            }
        } label: {
            Image(systemName: "forward.frame.fill")
                .makeCircly()
        }
        .disabled(isPlaying)
        .opacity(isPlaying ? 0.6 : 1)
    }

    private var resetButton: some View {
        Button {
            withAnimation {
                isChanged = false
            }
        } label: {
            Image(systemName: "stop.fill")
                .makeCircly(background: .red)
        }
        .disabled(isPlaying)
        .opacity(isPlaying ? 0.6 : 1)
    }
}


struct CirclyModifier: ViewModifier {
    let foreground: Color
    let background: Color
    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .foregroundStyle(foreground)
            .frame(width: 55, height: 55)
            .background(background, in: .circle)
    }
}

extension View {
    func makeCircly(
        foreground: Color = .white,
        background: Color = .blue
    ) -> some View {
        self.modifier(
            CirclyModifier(foreground: foreground,
                           background: background)
        )
    }
}
