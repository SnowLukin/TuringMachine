//
//  Folder.swift
//  TuringMachine
//
//  Created by Snow Lukin on 27.11.2023.
//

import Foundation

struct Folder: Identifiable, Codable {
    let id: String
    let name: String
    let algorithms: [Algorithm]
}

extension Folder {
    init(from folder: CDFolder) {
        self.id = folder.id ?? UUID().uuidString
        self.name = folder.name.unwrapped
        self.algorithms = folder.unwrappedAlgorithms.map { Algorithm(from: $0) }
    }
}
