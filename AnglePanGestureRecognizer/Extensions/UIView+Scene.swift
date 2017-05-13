//
//  UIView+Scene.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

extension UIView: Locatable {
    public var position: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
}

extension UIView: Scene {
    public typealias Node = UIView

    public func animateCompletion(for scene: UIView, node: Node, position: CGPoint) {}

    public func convertPoint(toView point: CGPoint) -> CGPoint {
        return convert(point, to: self)
    }

    public func convertPoint(fromView point: CGPoint) -> CGPoint {
        return point
    }

}
