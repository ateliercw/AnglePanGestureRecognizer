//
//  SKScene+Extensions.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode: Locatable {
}

extension SKScene: Scene {
    typealias Node = SKNode

    func animateCompletion(for scene: SKScene, node: Node, position: CGPoint) {
        let finalPosition = scene.convertPoint(fromView: position)
        let action = SKAction.move(to: finalPosition, duration: 0.2)

        scene.view?.isUserInteractionEnabled = false
        node.run(action) { [unowned scene] in
            scene.view?.isUserInteractionEnabled = true
        }
    }

}
