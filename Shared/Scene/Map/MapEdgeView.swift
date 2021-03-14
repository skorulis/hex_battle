//
//  MapEdgeView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation
import CGPointVector
import SwiftUI

// MARK: - Memory footprint

struct MapEdgeView {
    
    let viewModel: MapEdgeViewModel
    let lineWidth: CGFloat = 3
    @State private var forwardPhase: CGFloat = 10
    @State private var backwardsPhase: CGFloat = 10
    
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
        ZStack {
            forwardsLine
                .frame(width: size.width, height: size.height)
                .position(x: minX + size.width/2, y: minY + size.height/2)
            backwardsLine
                .frame(width: size.width, height: size.height)
                .position(x: minX + size.width/2, y: minY + size.height/2)
        }
        .onAppear(perform: startAnimation)
        
    }
    
    private var forwardsLine: some View {
        line(from: node1.point, to: node2.point)
            .stroke(style: strokeStyle(phase: forwardPhase))
            .foregroundColor(viewModel.type1.baseColor)
    }
    
    private var backwardsLine: some View {
        line(from: node2.point, to: node1.point)
            .stroke(style: strokeStyle(phase: backwardsPhase))
            .foregroundColor(viewModel.type2.baseColor)
    }
    
    private func line(from: CGPoint, to: CGPoint) -> Path {
        let dir = (from - to).unit
        let offset = lineWidth/2 * dir * CGAffineTransform(rotationAngle: CGFloat.pi/2)
        let start = from - minPoint + offset
        let end = to - minPoint + offset
        return Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
    
    var size: CGSize {
        let width = abs(node1.x - node2.x) + lineWidth
        let height = abs(node1.y - node2.y) + lineWidth
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    private func strokeStyle(phase: CGFloat) -> StrokeStyle {
        return StrokeStyle(lineWidth: lineWidth, lineCap: .butt, dash: [10,2], dashPhase: phase)
    }
    
    var minPoint: CGPoint {
        let x = CGFloat(min(node1.x, node2.x))
        let y = CGFloat(min(node1.y, node2.y))
        return CGPoint(x: x, y: y)
    }
    
    var minX: CGFloat {
        return CGFloat(min(node1.x, node2.x))
    }
    
    var minY: CGFloat  {
        return CGFloat(min(node1.y, node2.y))
    }
    
}

// MARK: - Behaviours

extension MapEdgeView {
    
    private func startAnimation() {
        if viewModel.isFlowingForwards {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                forwardPhase -= 24
            }
        }
        if viewModel.isFlowingBackwards {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                backwardsPhase -= 24
            }
        }
    }
    
}

// MARK: - Previews

struct MapEdgeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let node1 = HexMapNode(id: 1, x: 50, y: 50, initialState: nil)
        let node2 = HexMapNode(id: 2, x: 150, y: 90, initialState: nil)
        let node3 = HexMapNode(id: 3, x: 70, y: 160, initialState: nil)
        let node4 = HexMapNode(id: 4, x: 200, y: 60, initialState: nil)
        
        let vm1 = MapEdgeViewModel(node1: node1, node2: node2,
                                   type1: .alpha, type2: .beta)
        
        let vm2 = MapEdgeViewModel(node1: node2, node2: node3,
                                   type1: .beta, type2: .passive)
        
        let vm3 = MapEdgeViewModel(node1: node1, node2: node4,
                                   type1: .alpha, type2: .command)
        
        ZStack {
            MapEdgeView(viewModel: vm1)
            MapEdgeView(viewModel: vm2)
            MapEdgeView(viewModel: vm3)
        }
        .frame(width: 200, height: 200)
    }
}

