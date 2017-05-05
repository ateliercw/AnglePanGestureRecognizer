//
//  Grid.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

public struct Grid<TileData>: ExpressibleByArrayLiteral {

    public static var initial: Grid<TileData> { return Grid(tiles: []) }

    fileprivate(set) var tiles: [GridPoint: TileData] = [:]

    init(tiles: [GridTile<TileData>]) {
        var tilesDictionary = [GridPoint: TileData]()
        for tile in tiles {
            tilesDictionary[tile.point] = tile.value
        }
        self.tiles = tilesDictionary
    }

    public init(arrayLiteral elements: GridTile<TileData>...) {
        var tilesDictionary = [GridPoint: TileData]()
        for tile in elements {
            tilesDictionary[tile.point] = tile.value
        }
        self.tiles = tilesDictionary
    }

    subscript (point: GridPoint) -> TileData? {
        get {
            return tiles[point]
        }
        set {
            tiles[point] = newValue
        }
    }

    func tile(at point: GridPoint) -> GridTile<TileData>? {
        return self[point].map { GridTile(point: point, value: $0) }
    }

    public func tiles(surrounding point: GridPoint) -> [GridTile<TileData>] {
        return point.surroundingCoordinates.flatMap(tile(at:))
    }

}
