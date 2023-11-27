//
//  Folder.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct Folder: Codable {
    let name: String
    let algorithms: [Algorithm]
}

extension Folder {
    init(from folder: CDFolder) {
        self.name = folder.name.unwrapped
        self.algorithms = folder.unwrappedAlgorithms.map { Algorithm(from: $0) }
    }
}
