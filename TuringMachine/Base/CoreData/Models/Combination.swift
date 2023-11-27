//
//  Combination.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct Combination: Codable {
    let id: String
    let fromChar: String
    let toChar: String
    let directionIndex: Int
    var option: Option?
}

extension Combination {
    init(from cdEntity: CDCombination) {
        self.id = cdEntity.id.unwrapped
        self.fromChar = cdEntity.fromChar.unwrapped
        self.toChar = cdEntity.toChar.unwrapped
        self.directionIndex = Int(cdEntity.directionIndex)
        if let cdOption = cdEntity.option {
            self.option = Option(from: cdOption)
        }
    }
}
