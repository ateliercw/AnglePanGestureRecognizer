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
        v.frame = CGRect(origin: .zero, size: CGSize(width: 35.0, height: 35.0))
        v.layer.cornerRadius = 17.5
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

    fileprivate lazy var grid: Grid<TileState> = {
        return GridGenerator.generateBoard(with: (self.generateNode(gridPoint:)),
                                           width: 7,
                                           height: 7)
    }()

    fileprivate var moveModel: MoveModel<UIView>?

    fileprivate lazy var gameState: GameState = {
        return GameState(gestureState: GestureState.initial(for: self.playerView), grid: self.grid)
    }()

    func generateNode(gridPoint: GridPoint) -> TileState {
        let state = TileState(position: gridPoint, type: .traversable, node: node(at: gridPoint))
        return state
    }

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
        let gestureRecognizer = AnglePanGestureRecognizer(target: self, action: #selector(handlePan), unlockedMoveDelegate: self)
        view.addGestureRecognizer(gestureRecognizer)
    }

    func node(at gridpoint: GridPoint) -> UIView {
        return rowStackView.subviews[gridpoint.x].subviews[gridpoint.y]
    }

    func handlePan(recognizer: AnglePanGestureRecognizer) {
        recognizer.moveDistance = ((tileRadius + tileRadius) * (sqrt(3) / 2))
        switch recognizer.state {
        case .began:
            moveModel = MoveModel(node: gameState.gestureState.view, scene: view,
                                        radius: tileRadius)
            recognizer.allowedAngles = gameState.allowedMoves.flatMap { point in
                return gameState.gestureState.position.angle(facing: point)
            }
        case .cancelled:
            moveModel?.cancel()
            moveModel = nil
        case .ended:
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
        playerView.center = view.convert(firstTile.center, from: firstTile)
    }

}

extension TileViewController: AnglePanGestureRecognizerDelegate {
    func handleMove(for recognizer: AnglePanGestureRecognizer) {
        if let angle = recognizer.currentAngle, true {
            let newPosition = gameState.allowedMoves.first { point in
                return angle == gameState.gestureState.position.angle(facing: point)
            }
            if let finalPosition = newPosition {
                gameState.gestureState.position = finalPosition
            }
            let tile = node(at: gameState.gestureState.position)
            if let center = tile.superview?.convert(tile.center, to: view) {
                moveModel?.finish(completed: true,
                              finalOffset: center)
            }

        }
    }
}
