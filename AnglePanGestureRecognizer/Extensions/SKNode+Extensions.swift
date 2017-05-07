//
//  SKNode+Extensions.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/7/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode: Node {
    public var associatedScene: Scene { return self.scene! }
}
