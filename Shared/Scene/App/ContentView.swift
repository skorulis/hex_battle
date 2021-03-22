//
//  ContentView.swift
//  Shared
//
//  Created by Alexander Skorulis on 13/3/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ModalContainerView {
            AppCoordinatorView(ioc: IOCConfig.shared)
                .frame(width:400, height: 600)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.offWhite)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
