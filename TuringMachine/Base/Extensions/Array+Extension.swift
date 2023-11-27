//
//  Array+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 24.11.2023.
//

import Foundation

extension Array {
    func at(_ index: Int) -> Element? {
        if index > self.count || index < 0 {
            return nil
        }
        return self[index]
    }
}
