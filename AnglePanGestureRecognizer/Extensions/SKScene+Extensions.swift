//
//  SKScene+Extensions.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import SpriteKit

extension SKScene: Scene {

    public func animateCompletion(for scene: Scene, node: Node, position: CGPoint) {
        let finalPosition = scene.convertPoint(fromView: position)
        let action = SKAction.move(to: finalPosition, duration: 0.2)

        guard let node = node as? SKNode, let scene = scene as? SKScene else {
            // TODO: Throw error
            return
        }
        scene.view?.isUserInteractionEnabled = false
        node.run(action) { [unowned scene] in
            scene.view?.isUserInteractionEnabled = true
        }
    }

}
