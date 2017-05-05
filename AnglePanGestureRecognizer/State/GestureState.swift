//
//  GestureState.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 5/5/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit

public struct GestureState {

    public static func initial(for view: UIView) -> GestureState {
        return GestureState(position: GridPoint.zero, view: view)
    }

    public var view: UIView
    public var position: GridPoint

    init(position: GridPoint, view: UIView) {
        self.position = position
        self.view = view
    }

}
