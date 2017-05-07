//
//  UIView+Scene.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

extension UIView: Scene {
    public func animateCompletion(for scene: Scene, node: Node, position: CGPoint) throws {}


    public func convertPoint(toView point: CGPoint) -> CGPoint {
        return point
    }

    public func convertPoint(fromView point: CGPoint) -> CGPoint {
        return point
    }

}
