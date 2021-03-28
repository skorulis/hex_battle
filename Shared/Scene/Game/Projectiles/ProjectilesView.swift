//
//  ProjectilesView.swift
//  HexBattle
//
//  Created by Alexander Skorulis on 28/3/21.
//

import Combine
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ProjectilesView {
    
    @ObservedObject var viewModel: ProjectilesViewModel
}

// MARK: - Rendering

extension ProjectilesView: View {
    
    var body: some View {
        ZStack {
            ForEach(viewModel.missiles) { missile in
                MissileView(missile: missile)
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Previews

struct ProjectilesView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ProjectilesViewModel()
        viewModel.missiles.append(makeMissile())
        return VStack {
            ProjectilesView(viewModel: viewModel)
            HStack {
                Button(action: {
                    viewModel.missiles.append(makeMissile())
                }, label: {
                    Text("Add missile")
                })
            }
        }
        
    }
    
    static func makeMissile() -> Missile{
        let start = Date().timeIntervalSinceNow
        let dummySubscriber = Just("").sink { (text) in
            print("Text")
        }
        let event = EventTimeFrame(start: start, duration: start+1, subscriber: dummySubscriber)
        
        let missile = Missile(source: .zero, target: CGPoint(x: 200, y: 100), event: event)
        return missile
    }
}

