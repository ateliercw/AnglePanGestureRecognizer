//
//  GridPoint.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit

public struct GridPoint {

    static var zero: GridPoint { return GridPoint(q: 0, r: 0) }

    // Axial Coordinates
    var q: Int
    var r: Int

    // Cube Coordinates
    var x: Int { return q }
    var y: Int { return -q - r }
    var z: Int { return r }

    var surroundingCoordinates: [GridPoint] {
        return GridPoint.surroundingOffsets.map { self + $0 }
    }

    public init(q: Int, r: Int) {
        self.q = q
        self.r = r
    }

    public init?(x: Int, y: Int, z: Int) {
        guard x + y + z == 0 else {
            return nil
        }
        self.q = x
        self.r = z
    }

}

extension GridPoint {

    static func + (lhs: GridPoint, rhs: GridPoint) -> GridPoint! {
        return GridPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static func - (lhs: GridPoint, rhs: GridPoint) -> GridPoint! {
        return GridPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

}

extension GridPoint: Equatable {

    public static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }

}

extension GridPoint: Hashable {

    public var hashValue: Int {
        return x.hashValue | y.hashValue | x.hashValue
    }

}

public extension GridPoint {

    func angle(facing gridPoint: GridPoint) -> CGFloat? {
        return angleInFlatArrangment(facing: gridPoint)
    }

}

private extension GridPoint {

    func angleInFlatArrangment(facing gridPoint: GridPoint) -> CGFloat? {
        let angle: CGFloat?
        switch (self.q - gridPoint.q, self.r - gridPoint.r) {
        case (0, -1):
            angle = CGFloat.pi * (0/6)
        case (-1, 0):
            angle = CGFloat.pi * (2/6)
        case (-1, 1):
            angle = CGFloat.pi * (4/6)
        case (0, 1):
            angle = CGFloat.pi * (6/6)
        case (1, 0):
            angle = CGFloat.pi * (8/6)
        case (1, -1):
            angle = CGFloat.pi * (10/6)
        default:
            angle = nil
        }
        return angle
    }

}
private extension GridPoint {

    static let surroundingOffsets: [GridPoint] = {
        var points = (-1...1).grid.filter(ignoreCenter).flatMap(GridPoint.init)
        return points
    }()

    private static func ignoreCenter(x: Int, y: Int, z: Int) -> Bool {
        return !(x == 0 && y == 0 && z == 0)
    }

}
