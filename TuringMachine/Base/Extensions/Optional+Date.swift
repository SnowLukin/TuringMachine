//
//  Optional+Date.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import Foundation

extension Optional where Wrapped == Date {
    var unwrappedOrNow: Date {
        self ?? Date.now
    }
}
