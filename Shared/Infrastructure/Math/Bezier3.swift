//
//  Bezier3.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 2/4/21.
// https://stackoverflow.com/questions/60521118/how-to-move-a-view-shape-along-a-custom-path-with-swiftui
//

import Foundation

struct Bezier3: ParametricCurve {

    private let p0: CGPoint
    private let p1: CGPoint
    private let p2: CGPoint
    private let p3: CGPoint

    private let A: CGFloat
    private let B: CGFloat
    private let C: CGFloat
    private let D: CGFloat
    private let E: CGFloat
    private let F: CGFloat
    private let G: CGFloat
    private let H: CGFloat


    public private(set) var totalArcLength: CGFloat = .zero

    init(from: CGPoint, to: CGPoint, control1: CGPoint, control2: CGPoint) {
        p0 = from
        p1 = control1
        p2 = control2
        p3 = to
        A = to.x - 3 * control2.x + 3 * control1.x - from.x
        B = 3 * control2.x - 6 * control1.x + 3 * from.x
        C = 3 * control1.x - 3 * from.x
        D = from.x
        E = to.y - 3 * control2.y + 3 * control1.y - from.y
        F = 3 * control2.y - 6 * control1.y + 3 * from.y
        G = 3 * control1.y - 3 * from.y
        H = from.y
        // mandatory !!!
        totalArcLength = arcLength(t: 1)
    }

    func point(t: CGFloat)->CGPoint {
        let x = A * t * t * t + B * t * t + C * t + D
        let y = E * t * t * t + F * t * t + G * t + H
        return CGPoint(x: x, y: y)
    }

    func derivate(t: CGFloat)->CGVector {
        let dx = 3 * A * t * t + 2 * B * t + C
        let dy = 3 * E * t * t + 2 * F * t + G
        return CGVector(dx: dx, dy: dy)
    }

    func secondDerivate(t: CGFloat)->CGVector {
        let dx = 6 * A * t + 2 * B
        let dy = 6 * E * t + 2 * F
        return CGVector(dx: dx, dy: dy)
    }

}
