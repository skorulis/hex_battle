//
//  CircularProgress.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct CircularProgress {
    
    var progress: CGFloat
    let lineWidth: CGFloat
    
    init(
        progress: CGFloat,
        lineWidth: CGFloat = 20
        ) {
        self.progress = progress
        self.lineWidth = lineWidth
    }
    
}

// MARK: - Rendering

extension CircularProgress: View {
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
        .padding(lineWidth/2)
        
    }
}

// MARK: - Behaviours

extension CircularProgress {
    
    func animate(to progress: CGFloat, duration: TimeInterval) -> CircularProgress {
        var copy = self
        copy.progress = progress
        return copy
    }
}

// MARK: - Previews

struct CircularProgress_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreviewWrapper(false) { toggleOn in
            VStack {
                circle(progress: toggleOn.wrappedValue ? 0.8 : 0.3)
                    
                
                Toggle("Fill", isOn: toggleOn)
            }
            .padding()
        }
    }
    
    static func circle(progress: CGFloat) -> some View {
        CircularProgress(progress: progress, lineWidth: 5)
            .frame(width: 50, height: 50)
            .foregroundColor(.green)
    }
}

