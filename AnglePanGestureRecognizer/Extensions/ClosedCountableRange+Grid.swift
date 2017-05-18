//
//  ClosedCountableRange+Grid.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/3/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

public extension CountableClosedRange {

    // swiftlint:disable:next large_tuple
    var grid: [(Bound, Bound)] {
        var points = [(Bound, Bound)]()
        for x in self {
            for y in self {
                points.append((x, y))
            }
        }
        return points
    }

}
