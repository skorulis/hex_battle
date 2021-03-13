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
    
    init(model: HexMapNode, state: HexMapNodeState) {
        self.model = model
        self.state = state
    }
    
}

// MARK: - Rendering

extension HexMapNodeView: View {
    
    var body: some View {
        Button(action: {}, label: {
            Text(state.type.symbol)
        })
        .buttonStyle(HexMapNodeButtonStyle())
    }
}

// MARK: - ButtonStyle

private struct HexMapNodeButtonStyle:ButtonStyle {
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
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        }
        
    }
}

// MARK: - Previews

struct HexMapNodeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let model = HexMapNode(id: 1, x: 10, y: 10)
        let state = HexMapNodeState(type: .command)
        HexMapNodeView(model: model, state: state)
            .padding()
    }
}
