//
//  MoveModel.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

public struct MoveModel {

    let initialPosition: CGPoint
    let node: Node
    let scene: Scene

    // Generate a transform
    // finish, cancel and fail stay to plug in

    public init(node: Node, radius: CGFloat) {
        self.node = node
        self.scene = node.associatedScene
        self.initialPosition = scene.convertPoint(toView: node.position)
    }

    public func update(translation: CGPoint, velocity: CGPoint) {
        var tunedTranslation = initialPosition
        tunedTranslation.x += translation.x
        tunedTranslation.y += translation.y
        node.position = scene.convertPoint(fromView: tunedTranslation)
    }

    public func finish(completed: Bool, finalOffset: CGPoint) {
        let nodePosition: CGPoint
        if completed {
            var position = initialPosition
            position.x += finalOffset.x
            position.y += finalOffset.y
            nodePosition = position
        }
        else {
            nodePosition = initialPosition
        }
        do {
            try scene.animateCompletion(for: scene, node: node, position: nodePosition)
        }
        catch {
            // TODO: Log error here
        }
    }

    public func cancel() {
        node.position = initialPosition
    }

    public func fail() {
        node.position = initialPosition
    }

}
