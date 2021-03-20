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
            Color.red
            VStack {
                Button(action: self.onClose, label: {
                    Text("Close")
                })
                Text("Hello")
            }
            
        }
        .frame(width: 200, height: 200)
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

