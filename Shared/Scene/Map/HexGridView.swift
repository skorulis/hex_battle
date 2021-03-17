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
    
    let columns: Int
    let rows: Int
    private let grid: HexGrid
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = HexGrid()
    }
    
}

// MARK: - Rendering

extension HexGridView: View {
    
    var body: some View {
        ZStack {
            ForEach(0..<columns) { x in
                ForEach(0..<rows) { y in
                    let pos = grid.position(x: x, y: y)
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
                CGPoint(x: grid.width/4, y: 0),
                CGPoint(x: grid.width * 3/4, y: 0),
                CGPoint(x: grid.width, y: grid.height/2),
                CGPoint(x: grid.width * 3 / 4, y: grid.height),
                CGPoint(x: grid.width / 4, y: grid.height),
                CGPoint(x:0, y: grid.height / 2),
                CGPoint(x: grid.width/4, y: 0)
            ])
        }
        .stroke()
        .frame(width: grid.width, height: grid.height)
    }
    
}

// MARK: - Previews

struct HexGridView_Previews: PreviewProvider {
    
    static var previews: some View {
        HexGridView(rows: 4, columns: 5)
    }
}

