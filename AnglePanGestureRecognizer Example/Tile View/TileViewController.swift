//
//  TileViewController.swift
//  AnglePanGestureRecognizer Example
//
//  Created by Matthew Buckley on 4/20/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import UIKit
import AnglePanGestureRecognizer

class TileViewController: UIViewController {

    fileprivate let rowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    fileprivate let playerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.frame = CGRect(origin: .zero, size: CGSize(width: 50.0, height: 50.0))
        v.backgroundColor = .red
        return v
    }()

    fileprivate let gridView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate var tileRadius: CGFloat {
        return rowStackView.subviews.first?.frame.width ?? 0.0 / 2
    }

    fileprivate lazy var tileState: TileState = {
        return TileState(gestureState: GestureState.initial(for: self.playerView), grid: Grid.initial)
    }()

    fileprivate var moveModel: MoveModel<UIView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureGrid()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPlayer()
    }

    func setup() {
        view.backgroundColor = .white
        let gestureRecognizer = AnglePanGestureRecognizer(target: self, action: #selector(handlePan))
        playerView.addGestureRecognizer(gestureRecognizer)
    }

    func handlePan(recognizer: AnglePanGestureRecognizer) {
        recognizer.moveDistance = ((tileRadius + tileRadius) * (sqrt(3) / 2))
        switch recognizer.state {
        case .began:
            moveModel = MoveModel(node: tileState.gestureState.view, scene: view,
                                        radius: tileRadius)
            recognizer.allowedAngles = tileState.allowedMoves.flatMap { point in
                return tileState.gestureState.position.angle(facing: point)
            }
        case .cancelled:
            moveModel?.cancel()
            moveModel = nil
        case .ended:
            let completed = recognizer.percentComplete(in: view) > 0.5
            moveModel?.finish(completed: completed,
                              finalOffset: recognizer.finalOffset ?? CGPoint())
            if let angle = recognizer.currentAngle, completed {
                let newPosition = tileState.allowedMoves.first { point in
                    return angle == tileState.gestureState.position.angle(facing: point)
                }
                if let finalPosition = newPosition {
                    tileState.gestureState.position = finalPosition
                }
            }
            moveModel = nil
        case .failed:
            moveModel?.fail()
            moveModel = nil
        case .possible:
            break
        case .changed:
            let viewTranslation = recognizer.adjustedTranslation(in: view)
            let velocity = recognizer.velocity(in: view)
            moveModel?.update(translation: viewTranslation, velocity: velocity)
        }
    }
}

private extension TileViewController {

    func configureConstraints() {
        gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gridView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        gridView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

        rowStackView.topAnchor.constraint(equalTo: gridView.topAnchor, constant: 0.0).isActive = true
        rowStackView.rightAnchor.constraint(equalTo: gridView.rightAnchor, constant: 0.0).isActive = true
        rowStackView.bottomAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 0.0).isActive = true
        rowStackView.leftAnchor.constraint(equalTo: gridView.leftAnchor, constant: 0.0).isActive = true
    }

    func configureGrid() {
        view.addSubview(gridView)
        gridView.addSubview(rowStackView)
        configureConstraints()
        for _ in 0..<7 {
            let columnStackView = UIStackView()
            columnStackView.translatesAutoresizingMaskIntoConstraints = false
            columnStackView.axis = .vertical
            columnStackView.distribution = .fillEqually
            rowStackView.addArrangedSubview(columnStackView)
            for _ in 0..<7 {
                let tileView = TileView(frame: CGRect.zero)
                columnStackView.addArrangedSubview(tileView)
            }
        }
    }

    func addPlayer() {
        let firstTile = rowStackView.subviews[0].subviews[0]
        view.addSubview(playerView)
        let firstCenter = view.convert(firstTile.center, from: firstTile)
    }

}
