//
//  ViewController.swift
//  AnglePanGestureRecognizer Example
//
//  Created by Matthew Buckley on 4/20/17.
//  Copyright © 2017 Atelier Clockwork. All rights reserved.
//

import UIKit
import AnglePanGestureRecognizer

class ViewController: UIViewController {

    fileprivate let rowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    fileprivate let gridView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate var tileRadius: CGFloat {
        return rowStackView.subviews.first?.frame.width ?? 0.0 / 2
    }

    fileprivate lazy var state: State = {
        return State(userState: UserState.initial(for: self.view), grid: Grid(tiles: []))
    }()

    fileprivate var moveModel: MoveModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configureGrid()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        let gestureRecognizer = AnglePanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(gestureRecognizer)
    }

    func handlePan(recognizer: AnglePanGestureRecognizer) {
        recognizer.moveDistance = ((tileRadius + tileRadius) * (sqrt(3) / 2))
        switch recognizer.state {
        case .began:
            moveModel = MoveModel(tile: state.userState.view,
                                        radius: tileRadius)
            recognizer.allowedAngles = state.allowedMoves.flatMap { point in
                return state.userState.position.angle(facing: point)
            }
        case .cancelled:
            moveModel?.cancel()
            moveModel = nil
        case .ended:
            let completed = recognizer.percentComplete(in: view) > 0.5
            moveModel?.finish(completed: completed,
                              finalOffset: recognizer.finalOffset ?? CGPoint())
            if let angle = recognizer.currentAngle, completed {
                let newPosition = state.allowedMoves.first { point in
                    return angle == state.userState.position.angle(facing: point)
                }
                if let finalPosition = newPosition {
                    state.userState.position = finalPosition
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

private extension ViewController {

    func configureConstraints() {
        NSLayoutConstraint.activate([
            gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            gridView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),

            rowStackView.topAnchor.constraint(equalTo: gridView.topAnchor),
            rowStackView.rightAnchor.constraint(equalTo: gridView.rightAnchor),
            rowStackView.bottomAnchor.constraint(equalTo: gridView.bottomAnchor),
            rowStackView.leftAnchor.constraint(equalTo: gridView.leftAnchor),
        ])
    }

    func configureGrid() {
        view.addSubview(gridView)
        gridView.addSubview(rowStackView)
        configureConstraints()
        for _ in 0..<7 {
            let columnStackView = UIStackView()
            columnStackView.axis = .vertical
            columnStackView.distribution = .fillEqually
            rowStackView.addArrangedSubview(columnStackView)
            for _ in 0..<7 {
                let tileView = TileView(frame: CGRect.zero)
                columnStackView.addArrangedSubview(tileView)
            }
        }
    }

}


fileprivate struct State {

    var grid: Grid<State>
    var userState: UserState
    // TODO: don't hardcode this
    var isTraversable: Bool { return false }

    init(userState: UserState, grid: Grid<State>) {
        self.userState = userState
        self.grid = grid
    }

    var allowedMoves: [GridPoint] {
        let tiles = grid.tiles(surrounding: userState.position)
        let movableTiles = tiles.filter { $0.value.isTraversable }
        let points = movableTiles.map { $0.point }
        return points
    }

}

struct UserState {

    static func initial(for view: UIView) -> UserState {
        return UserState(position: GridPoint.zero, view: view)
    }

    var position: GridPoint
    var view: UIView

    init(position: GridPoint, view: UIView) {
        self.position = position
        self.view = view
    }

}

struct GridPoint {

    static var zero: GridPoint { return GridPoint(q: 0, r: 0) }

    // Axial Coordinates
    var q: Int
    var r: Int

    // Cube Coordinates
    var x: Int { return q }
    var y: Int { return -q - r }
    var z: Int { return r }

    var surroundingCoordinates: [GridPoint] {
        return GridPoint.surroundingOffsets.map { self + $0 }
    }

    public init(q: Int, r: Int) {
        self.q = q
        self.r = r
    }

    public init?(x: Int, y: Int, z: Int) {
        guard x + y + z == 0 else {
            return nil
        }
        self.q = x
        self.r = z
    }

}

extension GridPoint {

    static func + (lhs: GridPoint, rhs: GridPoint) -> GridPoint! {
        return GridPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static func - (lhs: GridPoint, rhs: GridPoint) -> GridPoint! {
        return GridPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

}

extension GridPoint: Equatable {

    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }

}

extension GridPoint: Hashable {

    var hashValue: Int {
        return x.hashValue | y.hashValue | x.hashValue
    }

}

extension GridPoint {

    func angle(facing gridPoint: GridPoint) -> CGFloat? {
        return angleInFlatArrangment(facing: gridPoint)
    }

}

private extension GridPoint {

    func angleInFlatArrangment(facing gridPoint: GridPoint) -> CGFloat? {
        let angle: CGFloat?
        switch (self.q - gridPoint.q, self.r - gridPoint.r) {
        case (0, -1):
            angle = CGFloat.pi * (0/6)
        case (-1, 0):
            angle = CGFloat.pi * (2/6)
        case (-1, 1):
            angle = CGFloat.pi * (4/6)
        case (0, 1):
            angle = CGFloat.pi * (6/6)
        case (1, 0):
            angle = CGFloat.pi * (8/6)
        case (1, -1):
            angle = CGFloat.pi * (10/6)
        default:
            angle = nil
        }
        return angle
    }

}
private extension GridPoint {

    static let surroundingOffsets: [GridPoint] = {
        var points = (-1...1).grid.filter(ignoreCenter).flatMap(GridPoint.init)
        return points
    }()

    private static func ignoreCenter(x: Int, y: Int, z: Int) -> Bool {
        return !(x == 0 && y == 0 && z == 0)
    }

}

private struct GridTile<TileData> {

    var point: GridPoint
    var value: TileData

    init(point: GridPoint, value: TileData) {
        self.point = point
        self.value = value
    }

}

private struct Grid<TileData>: ExpressibleByArrayLiteral {

    fileprivate(set) var tiles: [GridPoint: TileData] = [:]

    init(tiles: [GridTile<TileData>]) {
        var tilesDictionary = [GridPoint: TileData]()
        for tile in tiles {
            tilesDictionary[tile.point] = tile.value
        }
        self.tiles = tilesDictionary
    }

    init(arrayLiteral elements: GridTile<TileData>...) {
        var tilesDictionary = [GridPoint: TileData]()
        for tile in elements {
            tilesDictionary[tile.point] = tile.value
        }
        self.tiles = tilesDictionary
    }

    subscript (point: GridPoint) -> TileData? {
        get {
            return tiles[point]
        }
        set {
            tiles[point] = newValue
        }
    }

    func tile(at point: GridPoint) -> GridTile<TileData>? {
        return self[point].map { GridTile(point: point, value: $0) }
    }

    func tiles(surrounding point: GridPoint) -> [GridTile<TileData>] {
        return point.surroundingCoordinates.flatMap(tile(at:))
    }

}

private struct MoveModel {

    let initialFrame: CGRect
    let tile: UIView
    let containingView: UIView

    init(tile: UIView, radius: CGFloat) {
        self.tile = tile
        guard let containingView = tile.superview else {
            fatalError("Node must be in a scene to move")
        }
        self.containingView = containingView
        let initialOrigin = containingView.convert(tile.center, from: tile)
        initialFrame = CGRect(origin: initialOrigin, size: tile.frame.size)
    }

    func update(translation: CGPoint, velocity: CGPoint) {
        var tunedTranslation = initialFrame.origin
        tunedTranslation.x += translation.x
        tunedTranslation.y += translation.y
        tile.frame = CGRect(origin: tunedTranslation, size: initialFrame.size)
    }

    func finish(completed: Bool, finalOffset: CGPoint) {
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

    func cancel() {
        tile.frame = initialFrame
    }

    func fail() {
        tile.frame = initialFrame
    }

}
