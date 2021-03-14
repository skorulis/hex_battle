//
//  HexGridView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct HexGridView {
    
    let hexSize: CGFloat = 40
    let columns: Int
    let rows: Int
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
    }
    
}

// MARK: - Rendering

extension HexGridView: View {
    
    var body: some View {
        ZStack {
            ForEach(0..<columns) { x in
                ForEach(0..<rows) { y in
                    let pos = position(x: x, y: y)
                    hex
                        .position(x: pos.x,y: pos.y)
                }
            }
            
                
                
        }
        EmptyView()
    }
    
    private var hex: some View {
        return Path { path in
            path.addLines([
                CGPoint(x: width/4, y: 0),
                CGPoint(x: width * 3/4, y: 0),
                CGPoint(x: width, y: height/2),
                CGPoint(x: width * 3 / 4, y: height),
                CGPoint(x: width / 4, y: height),
                CGPoint(x:0, y: height / 2),
                CGPoint(x: width/4, y: 0)
            ])
        }
        .stroke()
        .frame(width: width, height: height)
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

// MARK: - Previews

struct HexGridView_Previews: PreviewProvider {
    
    static var previews: some View {
        HexGridView(rows: 4, columns: 5)
    }
}

