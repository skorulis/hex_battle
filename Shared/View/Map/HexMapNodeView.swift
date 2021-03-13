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
    
    init(model: HexMapNode) {
        self.model = model
    }
    
}

// MARK: - Rendering

extension HexMapNodeView: View {
    
    var body: some View {
        Circle()
            .frame(width: RenderConstants.nodeRadius * 2, height: RenderConstants.nodeRadius * 2)
    }
}

// MARK: - Previews

struct HexMapNodeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let model = HexMapNode(id: 1, x: 10, y: 10)
        HexMapNodeView(model: model)
    }
}
