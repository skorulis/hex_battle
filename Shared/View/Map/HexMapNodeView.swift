//
//  HexMapNodeView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

// MARK: - Memory footprint

struct HexMapNodeView {
    
    let model: HexMapNode
    let state: HexMapNodeState
    let selected: Bool
    let action: () -> Void
    
    init(
        model: HexMapNode,
        state: HexMapNodeState,
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

extension HexMapNodeView: View {
    
    var body: some View {
        Button(action: action, label: {
            Text(state.type.symbol)
        })
        .buttonStyle(HexMapNodeButtonStyle(selected: selected))
    }
}

// MARK: - ButtonStyle

private struct HexMapNodeButtonStyle:ButtonStyle {
    
    private let selected: Bool
    
    init(selected: Bool) {
        self.selected = selected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .background(circleBackground(configuration: configuration))
    }
    
    @ViewBuilder
    private func circleBackground(configuration: Configuration) -> some View {
        if configuration.isPressed {
            Circle()
                .fill(Color.offWhite)
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                        .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 8)
                        .blur(radius: 4)
                        .offset(x: -2, y: -2)
                        .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                )
        } else {
            Circle()
                .fill(Color.offWhite)
                .shadow(color: darkColor.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: lightColor.opacity(0.7), radius: 10, x: -5, y: -5)
        }
        
    }
    
    private var lightColor: Color {
        if selected {
            return Color.mixed(colors: [Color.white, Color.peterRiver])
        } else {
            return Color.white
        }
    }
    
    private var darkColor: Color {
        if selected {
            return Color.mixed(colors: [Color.black, Color.peterRiver])
        } else {
            return Color.black
        }
        
    }
}

// MARK: - Previews

struct HexMapNodeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let model = HexMapNode(id: 1, x: 10, y: 10, initialState: nil)
        let state = HexMapNodeState(type: .command)
        HexMapNodeView(
            model: model,
            state: state,
            selected: true,
            action: {}
        )
            .padding()
    }
}
