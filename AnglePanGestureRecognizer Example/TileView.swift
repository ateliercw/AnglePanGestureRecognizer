//
//  TileView.swift
//  AnglePanGestureRecognizer
//
//  Created by Matthew Buckley on 4/30/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import Foundation
import UIKit

class TileView: UIView {

    let circleView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2.0
        view.layer.masksToBounds = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(circleView)

        circleView.topAnchor.constraint(equalTo: topAnchor, constant: 2.5).isActive = true
        circleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.5).isActive = true
        circleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2.5).isActive = true
        circleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2.5).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = (frame.height / 2.0) - 2.0
    }

}
