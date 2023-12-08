//
//  SwiftUIMapAppApp.swift
//  SwiftUIMapApp
//
//  Created by Hakob Ghlijyan on 06.12.2023.
//

import SwiftUI

@main
struct SwiftUIMapAppApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
