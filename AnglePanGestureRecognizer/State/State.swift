//
//  State.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

public struct TileState {

    public var gestureState: GestureState
    public var allowedMoves: [GridPoint] {
        let tiles = grid.tiles(surrounding: gestureState.position)
        let movableTiles = tiles.filter { $0.value.isTraversable }
        let points = movableTiles.map { $0.point }
        return points
    }

    var grid: Grid<TileState>
    private var type: TileType = .traversable
    var isTraversable: Bool { return type.isTraversable }

    public init(gestureState: GestureState, grid: Grid<TileState>) {
        self.gestureState = gestureState
        self.grid = grid
    }

}

private enum TileType {

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
