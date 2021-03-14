//
//  MapEdgeView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct MapEdgeView {
    
    let viewModel: MapEdgeViewModel
    let lineWidth: CGFloat = 3
    @State var dashPhase: CGFloat = 10
    
    init(viewModel: MapEdgeViewModel) {
        self.viewModel = viewModel
    }
    
    var node1: HexMapNode {
        return viewModel.node1
    }
    
    var node2: HexMapNode {
        return viewModel.node2
    }
    
}

// MARK: - Rendering

extension MapEdgeView: View {
    
    var body: some View {
        line
            .frame(width: size.width, height: size.height)
            .position(x: minX + size.width/2, y: minY + size.height/2)
            .onAppear(perform: {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    dashPhase -= 24
                }
            })
    }
    
    private var line: some View {
        let strokeStyle = StrokeStyle(lineWidth: lineWidth, lineCap: .butt, dash: [10,2], dashPhase: dashPhase)
        
        return Path { path in
            path.move(to: CGPoint(x: node1.x - minX, y: node1.y - minY))
            path.addLine(to: CGPoint(x: node2.x - minX, y: node2.y - minY))
        }
        .stroke(style: strokeStyle)
    }
    
    var size: CGSize {
        let width = abs(node1.x - node2.x) + lineWidth
        let height = abs(node1.y - node2.y) + lineWidth
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    var minX: CGFloat {
        return CGFloat(min(node1.x, node2.x))
    }
    
    var minY: CGFloat  {
        return CGFloat(min(node1.y, node2.y))
    }
}

// MARK: - Previews

struct MapEdgeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let node1 = HexMapNode(id: 1, x: 50, y: 50, initialState: nil)
        let node2 = HexMapNode(id: 2, x: 150, y: 90, initialState: nil)
        let node3 = HexMapNode(id: 3, x: 70, y: 160, initialState: nil)
        let node4 = HexMapNode(id: 4, x: 200, y: 60, initialState: nil)
        
        let vm1 = MapEdgeViewModel(node1: node1, node2: node2)
        let vm2 = MapEdgeViewModel(node1: node2, node2: node3)
        let vm3 = MapEdgeViewModel(node1: node1, node2: node4)
        
        ZStack {
            MapEdgeView(viewModel: vm1)
            MapEdgeView(viewModel: vm2)
            MapEdgeView(viewModel: vm3)
        }
        .frame(width: 200, height: 200)
    }
}

