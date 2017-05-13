//
//  Scene.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

public protocol Locatable: class {
    var position: CGPoint { get set }
}

public protocol Scene {
    associatedtype Node: Locatable

    func convertPoint(toView point: CGPoint) -> CGPoint
    func convertPoint(fromView point: CGPoint) -> CGPoint
    func animateCompletion(for scene: Self, node: Node, position: CGPoint)
}
