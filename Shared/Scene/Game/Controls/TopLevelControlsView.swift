//
//  TopLevelControlsView.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct TopLevelControlsView<Content: View> {
    
    let content: Content
    @State var fullscreenView: FullScreenModel?
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
}

// MARK: - Rendering

extension TopLevelControlsView: View {
    
    var body: some View {
        ZStack {
            content
                .onPreferenceChange(FullScreenKey.self, perform: { value in
                    withAnimation {
                        if value.visible {
                            self.fullscreenView = value
                        } else {
                            self.fullscreenView = nil
                        }
                    }
                })
            fullscreenWrapper
        }
        
    }
    
    @ViewBuilder
    private var fullscreenWrapper: some View  {
        if let model = fullscreenView {
            model.content()
                .id(model.id)
                .transition(.opacity)
        } else {
            EmptyView()
        }
    }
    
}

// MARK: Preference keys

struct FullScreenModel: Equatable, Hashable {
    
    let id: String
    let visible: Bool
    let content: () -> AnyView
    
    
    
    static func == (lhs: FullScreenModel, rhs: FullScreenModel) -> Bool {
        return lhs.visible == rhs.visible &&
            lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(visible)
    }
    
}

struct FullScreenKey: PreferenceKey {
    static var defaultValue: FullScreenModel = FullScreenModel(
        id: "",
        visible: false,
        content: { AnyView(EmptyView()) }
    )
    
    static func reduce(value: inout FullScreenModel, nextValue: () -> FullScreenModel) {()
        value = nextValue()
    }
}

extension View {
    
    func fullscreen<Content: View>(
        id: String,
        visible: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let model = FullScreenModel(
            id: id,
            visible: visible,
            content: { AnyView(content()) }
        )
        return self
            .preference(key: FullScreenKey.self, value: model)
    }
    
    func fullScreen<Content: View, V>(
        id: String,
        item: V?,
        @ViewBuilder content: @escaping (V) -> Content
    ) -> some View {
        let model = FullScreenModel(
            id: id,
            visible: item != nil,
            content: {AnyView(content(item!))}
        )
        return self
            .preference(key: FullScreenKey.self, value: model)
    }
    
}

// MARK: - Previews

struct TopLevelControlsView_Previews: PreviewProvider {
    
    static var previews: some View {
        TopLevelControlsView {
            ZStack {
                Color.white
                Text("TEST")
                    .fullscreen(
                        id: "test1",
                        visible: true,
                        content: {
                            ZStack {
                                Color.red
                                Text("HAHA")
                            }
                        })
            }
        }
    }
}
