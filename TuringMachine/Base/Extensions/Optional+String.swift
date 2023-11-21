//
//  Optional+String.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var unwrapped: String {
        self ?? ""
    }
}
