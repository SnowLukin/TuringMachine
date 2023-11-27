//
//  Direction.swift
//  TuringMachine
//
//  Created by Snow Lukin on 26.11.2023.
//

import SwiftUI

enum Direction: Int, Identifiable, CaseIterable, Codable {
    case stay
    case left
    case right

    var id: String {
        switch self {
        case .stay:
            "stay"
        case .left:
            "left"
        case .right:
            "right"
        }
    }

    func image() -> Image {
        Image(systemName: imageName)
    }

    var imageName: String {
        switch self {
        case .stay:
            "arrow.counterclockwise"
        case .left:
            "arrow.left"
        case .right:
            "arrow.right"
        }
    }

    static func make(from index: Int) -> Direction {
        switch index {
        case 0:
            return .stay
        case 1:
            return .left
        default:
            return .right
        }
    }
}
