//
//  MachineState.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct MachineState: Identifiable, Codable {
    let id: String
    let name: String
    let options: [Option]
    var algorithm: Algorithm?
}

extension MachineState {
    init(from cdEntity: CDMachineState) {
        self.id = cdEntity.id.unwrapped
        self.name = cdEntity.name.unwrapped
        self.options = cdEntity.unwrappedOptions.map { Option(from: $0) }
        if let cdAlgorithm = cdEntity.algorithm {
            self.algorithm = Algorithm(from: cdAlgorithm)
        }
    }
}
