//
//  PlayStackViewModel.swift
//  TuringMachine
//
//  Created by Snow Lukin on 24.11.2023.
//

import SwiftUI
import CoreData

@MainActor
final class PlayingLogic: ObservableObject {

    @Published var algorithm: CDAlgorithm
    let context: NSManagedObjectContext
    private var autoStepTask: Task<Void, Never>?

    init(algorithm: CDAlgorithm) {
        self.algorithm = algorithm
        self.context = PersistenceController.shared.context
    }

    func reset() {
        withAnimation {
            pauseAutoSteps()

            algorithm.activeStateId = algorithm.startingStateId
            let tapes = algorithm.unwrappedTapes
            for tape in tapes {
                tape.workingHeadIndex = tape.headIndex
                tape.workingInput = tape.input
            }
            try? algorithm.save(in: context)
        }
    }

    func startAutoSteps() {
        autoStepTask?.cancel() // Cancel any existing task before starting a new one
        autoStepTask = Task {
            while !Task.isCancelled {
                makeStep()
                try? await Task.sleep(for: .seconds(0.4))
            }
        }
    }

    func pauseAutoSteps() {
        autoStepTask?.cancel()
        autoStepTask = nil
    }

    func makeStep() {
        withAnimation {
            // Gathering current combination
            let currentOptionCombination = getOptionCombinations()

            // Finding active State
            let states = algorithm.unwrappedStates
            let activeStateId = algorithm.activeStateId
            guard let state = states.first(where: { $0.id == activeStateId }) else {
                assertionFailure("Couldnt find active state.")
                return
            }

            // Finding fitting option
            guard let chosenOption = findOption(matching: currentOptionCombination, from: state) else {
                // Couldnt find correct option. Skipping the step.
                pauseAutoSteps()
                return
            }

            // Performing the step changing tape components
            for index in currentOptionCombination.indices {
                guard let currentTape = algorithm.unwrappedTapes.at(index) else {
                    assertionFailure("Couldnt find tape for fromChar.")
                    return
                }

                // Finding correct combination for current tape
                guard let combination = chosenOption.unwrappedCombinations.at(index) else {
                    assertionFailure("Couldnt find combination for tape.")
                    continue
                }

                // Checking if we can update the value in working tape input
                let headIndex = Int(currentTape.workingHeadIndex)
                let workingInputArray = currentTape.workingInput.unwrapped
                    .map { String($0) }
                if headIndex < 0 || headIndex > workingInputArray.count {
                    assertionFailure("Working Head Index bigger than workingInput.")
                    continue
                }

                // Updating working headIndex with direction in combination
                changeHeadIndex(tape: currentTape, combination: combination)
            }

            // Updating active state
            let toStateId = chosenOption.toStateId
            algorithm.activeStateId = toStateId

            // Saving context
            try? algorithm.save(in: context)
        }
    }

    private func getOptionCombinations() -> [String] {
        var currentOptionCombination: [String] = []
        let tapes = algorithm.unwrappedTapes
        for tape in tapes {
            let headIndex = Int(tape.workingHeadIndex)
            let workingInput = tape.workingInput.unwrapped
            let component = workingInput.at(headIndex, defaultValue: "-")
            currentOptionCombination.append(component)
        }
        return currentOptionCombination
    }

    private func findOption(matching chars: [String], from state: CDMachineState) -> CDOption? {
        let options = state.unwrappedOptions
        return options.first { option in
            let combinations = option.unwrappedCombinations
            let fromChars = combinations.map { combination in
                combination.fromChar ?? "-"
            }
            return chars == fromChars
        }
    }

    private func changeHeadIndex(tape: CDTape, combination: CDCombination) {
        let workingHeadIndex = Int(tape.workingHeadIndex)
        let workingInput = tape.workingInput.unwrapped

        switch combination.directionIndex {
        case 0: // stay
            break
        case 1: // left
            // checking if there is room for moving head index
            if workingHeadIndex - 1 > 0 {
                tape.workingHeadIndex -= 1
            }
        case 2: // right
            // checking if there is room for moving head index
            if workingHeadIndex + 1 < workingInput.count {
                tape.workingHeadIndex += 1
            }
        default: break
        }
    }
}
