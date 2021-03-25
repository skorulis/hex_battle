//
//  MapNodeView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

// MARK: - Memory footprint

struct MapNodeView {
    
    let model: HexMapNode
    let state: MapNodeState
    let selected: Bool
    let action: () -> Void
    
    init(
        model: HexMapNode,
        state: MapNodeState,
        selected: Bool,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.state = state
        self.selected = selected
        self.action = action
    }
    
}

// MARK: - Rendering

extension MapNodeView: View {
    
    var body: some View {
        Button(action: action, label: {
            if state.activeEffect == .none {
                Text("\(model.id)")
            } else {
                Image(systemName: state.activeEffect.iconName)
            }
        })
        .buttonStyle(RoundButtonStyle(selected: selected))
    }
}

// MARK: - Previews

struct MapNodeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let model = HexMapNode(id: 1, x: 10, y: 10, initialState: nil)
        let state = MapNodeState(id: 1, type: .command)
        MapNodeView(
            model: model,
            state: state,
            selected: true,
            action: {}
        )
            .padding()
    }
}
