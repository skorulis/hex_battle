//
//  ArcShape.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ArcShape {
    
    let fraction: Double
    
}

// MARK: - Rendering

extension ArcShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let rad = rect.size.width / 2
        let endAngle = Angle.degrees(fraction * 360) - Angle.degrees(90)
        p.addArc(center: CGPoint(x: rad, y: rad), radius: rad, startAngle: .degrees(-90), endAngle: endAngle, clockwise: false)

        return p
    }
}

// MARK: - Previews

struct ArcShape_Previews: PreviewProvider {
    
    static var previews: some View {
        ArcShape(fraction: 0.7)
            .fill(Color.green)
            //.stroke(Color.green, lineWidth: 5)
            .frame(width: 100, height: 100)
            
    }
}

