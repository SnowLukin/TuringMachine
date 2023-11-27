//
//  String+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 24.11.2023.
//

import Foundation

extension String {
    func at(_ index: Int, defaultValue: Character? = nil) -> String {
        if index > self.count || index < 0 {
            guard let defaultValue else { return "" }
            return String(defaultValue)
        }
        let strIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[strIndex])
    }
}
