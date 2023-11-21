//
//  MockDataGenerator.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import Foundation
import CoreData

struct MockDataGenerator {
    let context: NSManagedObjectContext

    func createData() {
        createFolders()
        try? context.save()
    }
}

private extension MockDataGenerator {
    @discardableResult
    func createFolders() -> [Folder] {
        [
            createFolder("Algorithms"),
            createFolder("Test folder 1"),
            createFolder("Test folder 2"),
            createFolder("Test folder 3"),
            createFolder("Test folder 4")
        ]
    }
    
    @discardableResult
    func createAlgorithms() -> [Algorithm] {
        [
            createAlgorithm("Test 1"),
            createAlgorithm("Test 2"),
            createAlgorithm("Test 3"),
            createAlgorithm("Test 4"),
            createAlgorithm("Test 5")
        ]
    }
    
    @discardableResult
    func createTapes() -> [Tape] {
        [
            createTape(),
            createTape(),
            createTape(),
            createTape()
        ]
    }
    
    @discardableResult
    func createStates() -> [StateQ] {
        [
            createState(),
            createState(),
            createState(),
            createState()
        ]
    }
    
    @discardableResult
    func createOptions(_ toStateId: String? = nil) -> [Option] {
        [
            createOption(toStateId: toStateId),
            createOption(toStateId: toStateId),
            createOption(toStateId: toStateId)
        ]
    }
    
    @discardableResult
    func createCombinations() -> [Combination] {
        [
            createCombination(char: "a", toChar: "b", direction: 0),
            createCombination(char: "b", toChar: "a", direction: 1),
            createCombination(char: "c", toChar: "b", direction: 2)
        ]
    }
    
    @discardableResult
    func createFolder(_ name: String) -> Folder {
        let folder = Folder(context: context)
        folder.id = UUID().uuidString
        folder.name = name
        createAlgorithms().forEach { folder.addToAlgorithms($0) }
        return folder
    }
    
    @discardableResult
    func createAlgorithm(_ name: String, date: Date = .now) -> Algorithm {
        let algorithm = Algorithm(context: context)
        algorithm.lastEditDate = date
        algorithm.createdDate = date
        algorithm.name = name
        algorithm.id = UUID().uuidString

        createTapes().forEach {
            algorithm.addToTapes($0)
        }

        createStates().forEach {
            algorithm.addToStates($0)
        }

        return algorithm
    }
    
    @discardableResult
    func createTape(_ id: String = UUID().uuidString) -> Tape {
        let tape = Tape(context: context)
        tape.id = id
        let padding = String(repeating: "-", count: 100)
        tape.input = padding + "aabbcca" + padding
        tape.headIndex = 100 // right after padding
        return tape
    }
    
    @discardableResult
    func createState(_ id: String = UUID().uuidString) -> StateQ {
        let state = StateQ(context: context)
        state.id = id
        createOptions(state.id).forEach {
            state.addToOptions($0)
        }
        return state
    }
    
    @discardableResult
    func createOption(_ id: String = UUID().uuidString, toStateId: String? = nil) -> Option {
        let option = Option(context: context)
        option.id = id
        option.toStateId = toStateId
        createCombinations().forEach {
            option.addToCombinations($0)
        }
        return option
    }
    
    @discardableResult
    func createCombination(_ id: String = UUID().uuidString, char: String, toChar: String, direction: Int) -> Combination {
        let combination = Combination(context: context)
        combination.id = id
        combination.fromChar = char
        combination.directionIndex = Int64(direction)
        combination.toChar = toChar
        return combination
    }
}
