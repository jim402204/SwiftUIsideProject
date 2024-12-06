//
//  leleIOSApp.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

@main
struct leleIOSApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkLoginStatus() // 初始化時檢查登錄狀態
    }
    
    func checkLoginStatus() {
        // 檢查 UserDefaults 中的 token
        
        let token = UserDefaultsHelper.token
        isLoggedIn = !(token?.isEmpty ?? true) // 如果 token 不為 nil 且不為空，則為已登錄
    }
    
    func logIn(token: String) {
        
        UserDefaultsHelper.token = token
//        UserDefaults.standard.set(token, forKey: "token")
        checkLoginStatus() // 更新登錄狀態
    }
    
    func logOut() {
        UserDefaultsHelper.token = nil
        
//        UserDefaults.standard.removeObject(forKey: "token")
        checkLoginStatus() // 更新登錄狀態
    }
}
