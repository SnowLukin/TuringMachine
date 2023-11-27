//
//  MockDataGenerator.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import Foundation
import CoreData

// MARK: Temprorary data for preview
// Will be changed

struct MockDataGenerator {
    let context: NSManagedObjectContext

    func createData() {
        createFolders()
        try? context.save()
    }
}

private extension MockDataGenerator {
    @discardableResult
    func createFolders() -> [CDFolder] {
        [
            createFolder("Algorithms"),
            createFolder("Test folder 1"),
            createFolder("Test folder 2"),
            createFolder("Test folder 3"),
            createFolder("Test folder 4")
        ]
    }

    @discardableResult
    func createAlgorithms() -> [CDAlgorithm] {
        [
            createAlgorithm("Test 1"),
            createAlgorithm("Test 2"),
            createAlgorithm("Test 3"),
            createAlgorithm("Test 4"),
            createAlgorithm("Test 5")
        ]
    }

    @discardableResult
    func createTapes(_ algorithm: CDAlgorithm) -> [CDTape] {
        [
            createTape(name: "CDTape 0", algorithm: algorithm),
            createTape(name: "CDTape 1", algorithm: algorithm),
            createTape(name: "CDTape 2", algorithm: algorithm),
            createTape(name: "CDTape 3", algorithm: algorithm)
        ]
    }

    @discardableResult
    func createStates(_ algorithm: CDAlgorithm) -> [CDMachineState] {
        [
            createState(name: "State 0", algorithm: algorithm),
            createState(name: "State 1", algorithm: algorithm),
            createState(name: "State 2", algorithm: algorithm),
            createState(name: "State 3", algorithm: algorithm)
        ]
    }

    @discardableResult
    func createOptions(_ toStateId: String? = nil) -> [CDOption] {
        [
            createOption(toStateId: toStateId),
            createOption(toStateId: toStateId),
            createOption(toStateId: toStateId)
        ]
    }

    @discardableResult
    func createCombinations() -> [CDCombination] {
        [
            createCombination(char: "a", toChar: "b", direction: 0),
            createCombination(char: "b", toChar: "a", direction: 1),
            createCombination(char: "c", toChar: "b", direction: 2)
        ]
    }

    @discardableResult
    func createFolder(_ name: String) -> CDFolder {
        let folder = CDFolder(context: context)
        folder.id = UUID().uuidString
        folder.name = name
        createAlgorithms().forEach { folder.addToAlgorithms($0) }
        return folder
    }

    @discardableResult
    func createAlgorithm(_ name: String, date: Date = .now) -> CDAlgorithm {
        let algorithm = CDAlgorithm(context: context)
        algorithm.lastEditDate = date
        algorithm.createdDate = date
        algorithm.name = name
        algorithm.id = UUID().uuidString

        createTapes(algorithm).forEach {
            algorithm.addToTapes($0)
        }

        createStates(algorithm).forEach {
            algorithm.addToStates($0)
            algorithm.activeStateId = $0.id
            algorithm.startingStateId = $0.id
        }

        return algorithm
    }

    @discardableResult
    func createTape(_ id: String = UUID().uuidString, name: String? = nil, algorithm: CDAlgorithm) -> CDTape {
        let tape = CDTape(context: context)
        tape.id = id
        tape.name = name ?? "CDTape \(algorithm.unwrappedTapes.count)"
        let padding = String(repeating: "-", count: 100)
        tape.input = padding + "aabbcca" + padding
        tape.headIndex = 100 // head index after padding
        tape.workingInput = tape.input
        tape.workingHeadIndex = tape.headIndex
        return tape
    }

    @discardableResult
    func createState(_ id: String = UUID().uuidString, name: String? = nil, algorithm: CDAlgorithm) -> CDMachineState {
        let state = CDMachineState(context: context)
        state.id = id
        state.name = name ?? "State \(algorithm.unwrappedStates.count)"
        createOptions(state.id).forEach {
            state.addToOptions($0)
        }
        return state
    }

    @discardableResult
    func createOption(_ id: String = UUID().uuidString, toStateId: String? = nil) -> CDOption {
        let option = CDOption(context: context)
        option.id = id
        option.toStateId = toStateId
        createCombinations().forEach {
            option.addToCombinations($0)
        }
        return option
    }

    @discardableResult
    func createCombination(
        _ id: String = UUID().uuidString,
        char: String,
        toChar: String,
        direction: Int
    ) -> CDCombination {
        let combination = CDCombination(context: context)
        combination.id = id
        combination.fromChar = char
        combination.directionIndex = Int64(direction)
        combination.toChar = toChar
        return combination
    }
}
