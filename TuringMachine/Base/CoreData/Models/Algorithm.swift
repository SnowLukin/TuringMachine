//
//  Algorithm.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct Algorithm: Identifiable, Codable {
    let id: String
    let name: String
    let algDescription: String
    let createdDate: Date
    let lastEditDate: Date
    let startingStateId: String
    let activeStateId: String
    let tapes: [Tape]
    let states: [MachineState]
    var folder: Folder?
}

extension Algorithm {
    init(from cdEntity: CDAlgorithm) {
        self.id = cdEntity.id.unwrapped
        self.name = cdEntity.name.unwrapped
        self.algDescription = cdEntity.algDescription.unwrapped
        self.createdDate = cdEntity.createdDate.unwrappedOrNow
        self.lastEditDate = cdEntity.lastEditDate.unwrappedOrNow
        self.startingStateId = cdEntity.startingStateId.unwrapped
        self.activeStateId = cdEntity.activeStateId.unwrapped
        self.tapes = cdEntity.unwrappedTapes.map { Tape(from: $0) }
        self.states = cdEntity.unwrappedStates.map { MachineState(from: $0) }
        if let cdFolder = cdEntity.folder {
            self.folder = Folder(from: cdFolder)
        }
    }
}
