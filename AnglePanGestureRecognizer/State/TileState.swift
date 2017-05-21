//
//  State.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit

struct TileState {

    var position: GridPoint
    var view: UIView

    private var type: TileType = .traversable
    var isTraversable: Bool { return type.isTraversable }

    init(position: GridPoint, type: TileType, node: UIView) {
        self.position = position
        self.type = type
        self.view = node
    }

}

enum TileType {

    case traversable, blocked

    var isTraversable: Bool {
        switch self {
        case .traversable:
            return true
        default:
            return false
        }
    }

}
