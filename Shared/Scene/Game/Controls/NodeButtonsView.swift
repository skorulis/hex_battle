//
//  NodeButtonsView.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct NodeButtonsView {
    
    static private let radius: CGFloat = 100
    
    private let node: MapNodeState
    private let onClose: () -> ()
    
    init(node: MapNodeState, onClose: @escaping () -> ()) {
        self.node = node
        self.onClose = onClose
    }
    
}

// MARK: - Rendering

extension NodeButtonsView: View {
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: NodeButtonsView.radius * 2, height: NodeButtonsView.radius * 2)
            VStack {
                Button(action: self.onClose, label: {
                    Text("Close")
                })
                Text("Hello")
            }
            
        }
        .frame(width: NodeButtonsView.radius * 2 + 50, height: NodeButtonsView.radius * 2 + 50)
    }
}

// MARK: - Previews

struct NodeButtonsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let node = MapNodeState(id: 1, type: .command, owner: 1, activeEffect: .turret, energyInputs: [:])
        NodeButtonsView(
            node: node,
            onClose: {}
            )
    }
}

