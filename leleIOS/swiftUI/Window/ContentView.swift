//
//  ContentView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
