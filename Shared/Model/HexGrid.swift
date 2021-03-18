//
//  HexGrid.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 15/3/21.
//

import Foundation
import CGPointVector

struct HexGrid {
 
    let hexSize: CGFloat
    
    init(hexSize: CGFloat = 80) {
        self.hexSize = hexSize
    }
    
    func position(x: Int, y: Int) -> CGPoint {
        let xPos = CGFloat(x) * 3*width/4 + width/2
        var yPos = CGFloat(y) * height + height/2
        if x % 2 == 1 {
            yPos += height/2
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    var width: CGFloat {
        return hexSize * 2
    }
    
    var height: CGFloat {
        return width * sqrt(3) / 2
    }
    
    var pathPoints: [CGPoint] {
        return [
            CGPoint(x: width/4, y: 0),
            CGPoint(x: width * 3/4, y: 0),
            CGPoint(x: width, y: height/2),
            CGPoint(x: width * 3 / 4, y: height),
            CGPoint(x: width / 4, y: height),
            CGPoint(x:0, y: height / 2),
            CGPoint(x: width/4, y: 0)
        ]
    }
    
    func pathPoints(x: Int, y: Int) -> [CGPoint] {
        let centre = position(x: x, y: y)
        return pathPoints.map { $0 + centre }
    }
    
}
