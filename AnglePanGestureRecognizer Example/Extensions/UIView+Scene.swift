//
//  UIView+Scene.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit

extension UIView: Locatable {
    var position: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
}

extension UIView: Scene {
    typealias Node = UIView

    func animateCompletion(for scene: UIView, node: Node, position: CGPoint) {}

    func convertPoint(toView point: CGPoint) -> CGPoint {
        return convert(point, to: self)
    }

    func convertPoint(fromView point: CGPoint) -> CGPoint {
        return point
    }

}
