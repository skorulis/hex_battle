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
                    self.updateAll(value)
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
    
    private func updateAll(_ dict: [String: FullScreenModel]) {
        dict.values.forEach { (model) in
            update(model)
        }        
    }
    
    private func update(_ value: FullScreenModel) {
        var existing = self.modals[value.id]
        if !value.visible && !(existing?.model.visible ?? false) {
            //No change, don't update
            return
        }
        
        if existing == nil {
            existing = FullScreenModalState(model: value, isOpen: false)
        }
        
        //Content function can only be changed while appearing
        if value.visible {
            existing?.model.content = value.content
        }
        
        if value.visible {
            existing?.model.visible = true
            let toHide = modals.keys.filter { (key) -> Bool in
                return key != value.id && modals[key]?.model.visible == true
            }
            for key in toHide {
                modals[key]?.isOpen = false
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.AnimationTime) {
                    self.modals.removeValue(forKey: key)
                }
            }
                
            // Run open action
            DispatchQueue.main.async {
                existing?.isOpen = true
                self.modals[value.id] = existing!
            }
            
        } else {
            existing?.isOpen = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.AnimationTime) {
                self.modals.removeValue(forKey: value.id)
            }
        }
        
        self.modals[value.id] = existing!
 
    }
}

// MARK: Preference keys

struct FullScreenModel: Equatable, Hashable {
    
    let id: String
    var visible: Bool
    var content: () -> AnyView
    
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
    static var defaultValue: [String: FullScreenModel] = [:]
    
    static func reduce(
        value: inout [String: FullScreenModel],
        nextValue: () -> [String: FullScreenModel]
    ) {
        value.merge(dict: nextValue())
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
            .preference(key: FullScreenKey.self, value: [model.id: model])
    }
    
    func fullScreen<Content: View, V>(
        id: String,
        item: V?,
        @ViewBuilder content: @escaping (V) -> Content
    ) -> some View {
        let builder: () -> (AnyView) = {
            return AnyView(content(item!))
        }
        
        let model = FullScreenModel(
            id: id,
            visible: item != nil,
            content: builder
        )
        return self
            .preference(key: FullScreenKey.self, value: [model.id: model])
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


extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
