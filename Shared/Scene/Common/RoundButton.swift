//
//  RoundButton.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 14/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct RoundButton {
    
}

// MARK: - Rendering

extension RoundButton: View {
    
    var body: some View {
        EmptyView()
    }
}

// MARK: - ButtonStyle

struct RoundButtonStyle:ButtonStyle {
    
    private let selected: Bool
    
    init(selected: Bool) {
        self.selected = selected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: RenderConstants.nodeRadius * 2, height: RenderConstants.nodeRadius * 2)
            .background(
                circleBackground(configuration: configuration)
                    .id("circle background")
            )
        
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

struct RoundButton_Previews: PreviewProvider {
    
    static var previews: some View {
        RoundButton()
    }
}

