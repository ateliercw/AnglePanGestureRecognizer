//
//  GameState.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/17/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

struct GameState {

    var gestureState: GestureState
    var allowedMoves: [GridPoint] {
        let tiles = grid.tiles(surrounding: gestureState.position)
        let movableTiles = tiles.filter { $0.value.isTraversable }
        let points = movableTiles.map { $0.point }
        return points
    }

    var grid: Grid<TileState>

    init(gestureState: GestureState, grid: Grid<TileState>) {
        self.gestureState = gestureState
        self.grid = grid
    }

}
