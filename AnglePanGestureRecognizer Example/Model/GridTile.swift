//
//  GridTile.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

struct GridTile<TileData> {

    var point: GridPoint
    var value: TileData

    init(point: GridPoint, value: TileData) {
        self.point = point
        self.value = value
    }

}
