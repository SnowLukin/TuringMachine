//
//  Tape.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct Tape: Identifiable, Codable {
    let id: String
    let name: String
    let input: String
    let workingInput: String
    let headIndex: Int
    let workingHeadIndex: Int
    var algorithm: Algorithm?
}

extension Tape {
    init(from cdEntity: CDTape) {
        self.id = cdEntity.id.unwrapped
        self.name = cdEntity.name.unwrapped
        self.input = cdEntity.input.unwrapped
        self.workingInput = cdEntity.workingInput.unwrapped
        self.headIndex = Int(cdEntity.headIndex)
        self.workingHeadIndex = Int(cdEntity.workingHeadIndex)
        if let cdAlgorithm = cdEntity.algorithm {
            self.algorithm = Algorithm(from: cdAlgorithm)
        }
    }
}
