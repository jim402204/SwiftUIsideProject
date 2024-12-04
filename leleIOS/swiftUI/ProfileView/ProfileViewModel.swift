//
//  ProfileViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var receiveNotifications = true
    private var appState: AppState?

    func setAppState(_ appState: AppState) {
        self.appState = appState
    }
    
    func logout() {
        appState?.isLoggedIn = false
    }
}
