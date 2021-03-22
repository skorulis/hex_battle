//
//  ModalContainerView.swift
//  HexBattleTests
//
//  Created by Alexander Skorulis on 20/3/21.
//

import Foundation

import SwiftUI

// MARK: - Memory footprint

struct ModalContainerView<Content: View> {
    
    let content: Content
    @State var modals: [String: FullScreenModalState] = [:]
    
    static var AnimationTime: TimeInterval {
        return 0.4
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
}

// MARK: - Rendering

extension ModalContainerView: View {
    
    var body: some View {
        ZStack {
            content
                .onPreferenceChange(FullScreenKey.self, perform: { value in
                    self.update(value   )
                })
            ForEach(Array(modals.keys), id:\.self) { key in
                modalView(modals[key]!)
                    
            }
        }
        
    }
    
    @ViewBuilder
    private func modalView(_ modal: FullScreenModalState) -> some View {
        if modal.model.visible {
            modal.model.content()
                .id(modal.model.id)
                .environment(\.fullscreenOpen, modal.isOpen)
        } else {
            EmptyView()
        }
        
    }
    
    private func update(_ value: FullScreenModel) {
        var existing = self.modals[value.id]
        if existing == nil {
            existing = FullScreenModalState(model: value, isOpen: false)
        }
        existing?.isOpen = false
        
        existing?.model = value

        self.modals[value.id] = existing!
        
        if value.visible {
            let toHide = modals.keys.filter { (key) -> Bool in
                return key != value.id && modals[key]?.model.visible == true
            }
            for key in toHide {
                modals[key]?.model.visible = false
            }
        }
        
        DispatchQueue.main.async {
            existing?.isOpen = true
            self.modals[value.id] = existing!
        }
        
        /*self.combinedViews[value.id] = existing
        
        DispatchQueue.main.async {
            leavingView?.visible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.AnimationTime) {
            self.leavingView = nil
        }
        
        if value.visible {
            self.fullscreenOpen = false
            self.fullscreenView = value
            if !self.fullscreenOpen {
                DispatchQueue.main.async {
                    self.fullscreenOpen = true
                }
            }
        } else {
            
            self.fullscreenView = nil
            self.fullscreenOpen = false
        }*/
    }
}

// MARK: Preference keys

struct FullScreenModel: Equatable, Hashable {
    
    let id: String
    var visible: Bool
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

struct FullScreenModalState: Equatable, Hashable {
    
    var model: FullScreenModel
    var isOpen: Bool
    
    static func == (lhs: FullScreenModalState, rhs: FullScreenModalState) -> Bool {
        return lhs.model == rhs.model &&
            lhs.isOpen == rhs.isOpen
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model)
        hasher.combine(isOpen)
    }
    
}

struct FullScreenKey: PreferenceKey {
    static var defaultValue: FullScreenModel = FullScreenModel(
        id: "",
        visible: false,
        content: { AnyView(EmptyView()) }
    )
    
    static func reduce(
        value: inout FullScreenModel,
        nextValue: () -> FullScreenModel
    ) {
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

// MARK: - Environment keys

struct FullScreenOpenKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    
    var fullscreenOpen: Bool {
        get { self[FullScreenOpenKey.self] }
        set { self[FullScreenOpenKey.self] = newValue }
    }
}

// MARK: - Previews

struct ModalContainerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ModalContainerView {
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

