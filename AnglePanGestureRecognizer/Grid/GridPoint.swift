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

    static var zero: GridPoint { return GridPoint(x: 0, y: 0) }

    // Cube Coordinates
    public var x: Int
    public var y: Int

    var surroundingCoordinates: [GridPoint] {
        return GridPoint.surroundingOffsets.map { self + $0 }
    }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

}

extension GridPoint {

    static func + (lhs: GridPoint, rhs: GridPoint) -> GridPoint! {
        return GridPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: GridPoint, rhs: GridPoint) -> GridPoint! {
        return GridPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

}

extension GridPoint: Equatable {

    public static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
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
        switch (self.x - gridPoint.x, self.y - gridPoint.y) {
        case (0, -1):
            angle = CGFloat.pi * (3/2)
        case (-1, 0):
            angle = CGFloat.pi * (4/2)
        case (0, 1):
            angle = CGFloat.pi * (1/2)
        case (1, 0):
            angle = CGFloat.pi * (2/2)
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

    private static func ignoreCenter(x: Int, y: Int) -> Bool {
        return !(x == 0 && y == 0)
    }

}
