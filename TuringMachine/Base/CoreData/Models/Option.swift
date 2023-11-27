//
//  Option.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct Option: Codable {
    let id: String
    let combinations: [Combination]
    let toStateId: String
    var state: MachineState?
}

extension Option {
    init(from cdEntity: CDOption) {
        self.id = cdEntity.id.unwrapped
        self.combinations = cdEntity.unwrappedCombinations.map { Combination(from: $0) }
        self.toStateId = cdEntity.toStateId.unwrapped
        if let cdState = cdEntity.state {
            self.state = Algorithm(from: cdState)
        }
    }
}
