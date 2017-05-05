//
//  MoveModel.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit

public struct MoveModel {

    let initialFrame: CGRect
    let tile: UIView
    let containingView: UIView

    public init(tile: UIView, radius: CGFloat) {
        self.tile = tile
        guard let containingView = tile.superview else {
            fatalError("Node must be in a scene to move")
        }
        self.containingView = containingView
        let initialOrigin = containingView.convert(tile.center, from: tile)
        initialFrame = CGRect(origin: initialOrigin, size: tile.frame.size)
    }

    public func update(translation: CGPoint, velocity: CGPoint) {
        var tunedTranslation = initialFrame.origin
        tunedTranslation.x += translation.x
        tunedTranslation.y += translation.y
        tile.frame = CGRect(origin: tunedTranslation, size: initialFrame.size)
    }

    public func finish(completed: Bool, finalOffset: CGPoint) {
        let finalFrame: CGRect
        if completed {
            var origin = initialFrame.origin
            origin.x += finalOffset.x
            origin.y += finalOffset.y
            finalFrame = CGRect(origin: origin, size: initialFrame.size)
        }
        else {
            finalFrame = initialFrame
        }

        UIView.animate(withDuration: 0.2, animations: { self.tile.frame = finalFrame })
    }

    public func cancel() {
        tile.frame = initialFrame
    }

    public func fail() {
        tile.frame = initialFrame
    }

}
