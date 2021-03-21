//
//  NodeButtonsView.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation
import SwiftUI
import CGPointVector

// MARK: - Memory footprint

struct NodeButtonsView {
    
    static private let radius: CGFloat = 100
    
    private let node: MapNodeState
    @Environment(\.fullscreenOpen) var isOpen: Bool
    private let onClose: () -> ()
    
    init(
        node: MapNodeState,
        onClose: @escaping () -> ()
    ) {
        self.node = node
        self.onClose = onClose
    }
    
}

// MARK: - Rendering

extension NodeButtonsView: View {
    
    var body: some View {
        ZStack {
            if self.isOpen {
                ForEach(0..<5) { index in
                    actionButton(index)
                    
                }
            }
        }
        .frame(width: NodeButtonsView.radius * 2, height: NodeButtonsView.radius * 2 )
        .animation(.easeIn, value: isOpen)
        .padding(50)
    }
    
    private func actionButton(_ index: Int) -> some View {
        let offset = buttonPosition(index)
        return Button(action: {}, label: {
            Text("\(index)")
        })
        .id("button-\(index)")
        .zIndex(Double(index)*2)
        .buttonStyle(RoundButtonStyle(selected: false))
        .offset(offset)
        .animation(Animation.default.delay(Double(index) * 0.06))
        .transition(
            AnyTransition.offset(x: -offset.width, y: -offset.height)
                .combined(with: .opacity)
        )
    }
    
    private func buttonPosition(_ index: Int) -> CGSize {
        let rotationAngle: CGFloat = CGFloat(index) * CGFloat.pi / 4
        let start = CGPoint(x: 0, y: -NodeButtonsView.radius)
        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
        let vector = start * rotation
        return CGSize(width: vector.x, height: vector.y)
    }
}

// MARK: - Previews

struct NodeButtonsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let node = MapNodeState(id: 1, type: .command, owner: 1, activeEffect: .turret, energyInputs: [:])
        StatefulPreviewWrapper(true) { binding in
            VStack {
                Toggle("Show buttons", isOn: binding)
                if binding.wrappedValue {
                    NodeButtonsView(
                        node: node,
                        onClose: {}
                        )
                    .id("TEST")
                } else {
                    EmptyView()
                }
            }
            .frame(width: 400, height: 400)
            
            
        }
        
    }
}

