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

    func handlePan(recognizer: AnglePanGestureRecognizer) {}

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
