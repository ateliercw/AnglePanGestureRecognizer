//
//  UIView+Node.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

extension UIView: Node {
    public var associatedScene: Scene {
        return self.superview!
    }

    public var position: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
}
