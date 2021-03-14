//
//  BuildProgressView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct BuildProgressView {
    
    @State var progress: CGFloat = 0
    let type: NodeType
    let target: Target?
    
    init(
        type: NodeType,
        target:Target? = nil
    ) {
        self.type = type
        self.target = target
    }
}

// MARK: - Rendering

extension BuildProgressView: View {
    
    var body: some View {
        ZStack {
            CircularProgress(progress: progress, lineWidth: 3)
                .frame(width: 30, height: 30)
                .foregroundColor(type.baseColor)
            Text(type.symbol)
        }
        .onAppear(perform: {
            if let target = target {
                progress = target.initial
                withAnimation(.linear(duration: target.duration)) {
                    progress = target.final
                }
            }
            
        })
    }
}

// MARK: - Inner types

extension BuildProgressView {
    
    struct Target {
        let initial: CGFloat
        let final: CGFloat
        let duration: TimeInterval
    }
}

// MARK: - Previews

struct BuildProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        let target = BuildProgressView.Target(initial: 0.3, final: 1, duration: 4)
        BuildProgressView(type: .gamma, target: target)
            .padding()
    }
}

