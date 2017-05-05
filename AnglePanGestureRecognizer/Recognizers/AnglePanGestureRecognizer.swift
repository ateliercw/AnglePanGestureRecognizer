//
//  AnglePanGestureRecognizer.swift
//  AnglePanGestureRecognizer
//
//  Created by Michael Skiba on 4/19/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import UIKit

import UIKit

private struct MovementVector {

    /// The the distance moved
    var distance: CGFloat

    /// The angle of motion in radians, expressed in clockwise rotation from the 12 o'clock position
    var angle: CGFloat

    init(distance: CGFloat, angle: CGFloat) {
        self.distance = distance
        self.angle = angle
    }

    init(point: CGPoint) {
        self = MovementVector(x: point.x, y: point.y)
    }

    init(x: CGFloat, y: CGFloat) {
        self.distance = (x * x + y * y).squareRoot()
        guard self.distance > 0 else {
            self.angle = 0
            return
        }
        let offset: CGFloat
        let leg: CGFloat
        switch (x, y) {
        // Quadrant I in the cartesian plane
        case (0...CGFloat.greatestFiniteMagnitude,
              -CGFloat.greatestFiniteMagnitude..<0):
            offset = 0
            leg = x
        // Quadrant II in the cartesian plane
        case (0...CGFloat.greatestFiniteMagnitude,
              0...CGFloat.greatestFiniteMagnitude):
            offset = CGFloat.pi * 0.5
            leg = y
        // Quadrant III in the cartesian plane
        case (-CGFloat.greatestFiniteMagnitude..<0,
              0...CGFloat.greatestFiniteMagnitude):
            offset = CGFloat.pi
            leg = -x
        // Quadrant IV in the cartesian plane
        case (-CGFloat.greatestFiniteMagnitude..<0,
              -CGFloat.greatestFiniteMagnitude..<0):
            offset = CGFloat.pi * 1.5
            leg = -y
        default:
            self.angle = 0
            return
        }
        self.angle = asin(leg / self.distance) + offset
    }

    var offset: CGPoint {
        let s1 = sin(self.angle) * self.distance
        let s2 = -cos(self.angle) * self.distance
        return CGPoint(x: s1, y: s2)
    }

    mutating func converge(with vector: MovementVector) {
        let difference = MovementVector.differenceBetween(angle, and: vector.angle)
        if difference < CGFloat.pi / 2 {
            let percent = ((CGFloat.pi / 2) - difference) / (CGFloat.pi / 2)
            distance *= percent
        }
        else {
            distance = 0
        }
        angle = vector.angle
    }

    /// Returns the smaller of 2 angles from the current angle (self.angle)i
    ///
    /// - Parameters:
    ///   - lhs: an angle (expressed in radians)
    ///   - rhs: an angle (expressed in radians)
    /// - Returns: the smaller of the 2 angles (when each angle is compared with self.angle)
    func sortByDifference(lhs: CGFloat, rhs: CGFloat) -> Bool {
        return MovementVector.differenceBetween(angle, and: lhs) < MovementVector.differenceBetween(angle, and: rhs)
    }

    /// Calculates the angle (expressed in radians) between 2 angles
    ///
    /// - Parameters:
    ///   - angle1: an angle expressed in radians
    ///   - angle2: an angle expressed in radians
    /// - Returns: an angle expressed in radians
    private static func differenceBetween(_ angle1: CGFloat, and angle2: CGFloat) -> CGFloat {
        let high = max(angle1, angle2)
        let low = min(angle1, angle2)
        let diff: CGFloat
        if (high > CGFloat.pi) && (low < CGFloat.pi) {
            diff = (low + (CGFloat.pi * 2)) - high
        }
        else {
            diff = high - low
        }
        return diff
    }

}

public final class AnglePanGestureRecognizer: UIPanGestureRecognizer {

    /// A collection of angles (expressed in radians) representing the permitted
    // directions in which the gesture can progress
    public var allowedAngles: [CGFloat] = []

    /// Distance traveled of the current gesture, in points
    public var moveDistance: CGFloat?

    /// The minimum distance that a gesture must travel
    var unlockedMoveDistance: CGFloat = 5

    /// The max angle (expressed in radians) that can exist bewteen the gesture's
    /// current angle and the angle of the next "move"
    fileprivate var maxAngleDifference: CGFloat = CGFloat.pi / 4
    public fileprivate(set) var currentAngle: CGFloat?

    /// The point to corresponding to the current MovementVector
    public var finalOffset: CGPoint? {
        guard let angle = currentAngle, let distance = moveDistance else {
            return nil
        }
        return MovementVector(distance: distance, angle: angle).offset
    }

    public func percentComplete(in view: UIView?) -> CGFloat {
        guard let maxDistance = moveDistance else {
            return 0
        }
        let currentDistance = adjustedVector(in: view).distance
        return min(currentDistance / maxDistance, 1)
    }

    func reset() {
        currentAngle = nil
    }

    /// Calculates the translation of the current vector
    /// in the view passed in.
    ///
    /// - Parameter view: a UIView.
    /// - Returns: a point in the view passed in.
    public func adjustedTranslation(in view: UIView?) -> CGPoint {
        return adjustedVector(in: view).offset
    }

}

private extension AnglePanGestureRecognizer {

    func adjustedVector(in view: UIView?) -> MovementVector {
        let initialVector = MovementVector(point: translation(in: view))
        if initialVector.distance >= unlockedMoveDistance && currentAngle == nil {
            currentAngle = allowedAngles.sorted(by: initialVector.sortByDifference).first { angle in
                return abs(angle - initialVector.angle) < maxAngleDifference
            }
        }
        var adjustedVector = initialVector
        if let currentAngle = currentAngle {
            let convergingVector = MovementVector(distance: initialVector.distance,
                                                  angle: currentAngle)
            adjustedVector.converge(with: convergingVector)
        }
        if adjustedVector.distance > moveDistance ?? -CGFloat.greatestFiniteMagnitude {
            adjustedVector.distance = moveDistance ?? 0
        }
        if allowedAngles.isEmpty || currentAngle == nil {
            adjustedVector.distance = min(adjustedVector.distance, unlockedMoveDistance)
        }
        return adjustedVector
    }

}
