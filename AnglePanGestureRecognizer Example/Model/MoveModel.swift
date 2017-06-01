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

struct MoveModel<MoveData: Scene> {

    var position: CGPoint
    let scene: MoveData
    let node: MoveData.Node

    init(node: MoveData.Node, scene: MoveData, radius: CGFloat) {
        self.node = node
        self.scene = scene
        self.position = scene.convertPoint(toView: node.position)
    }

    mutating func update(translation: CGPoint, velocity: CGPoint) {
        position.x += translation.x
        position.y += translation.y
    }

    mutating func finish(completed: Bool, finalOffset: CGPoint) {
        let mutableNode = node
        UIView.animate(withDuration: 1.0, animations: {
            mutableNode.position = finalOffset
        })
    }

    func cancel() {
        node.position = position
    }

    func fail() {
        node.position = position
    }

}
