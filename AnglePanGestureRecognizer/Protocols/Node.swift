//
//  Node.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation

public protocol Node: class {
    var position: CGPoint { get set }
    var associatedScene: Scene { get }
}
