//
//  HexGrid.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 15/3/21.
//

import Foundation

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
    
}
