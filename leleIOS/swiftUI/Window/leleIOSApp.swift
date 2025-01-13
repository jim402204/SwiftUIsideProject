//
//  leleIOSApp.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

@main
struct leleIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @State var loadingManager = LoadingManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .loadingOverlay(isLoading: $loadingManager.isLoading)
                .environmentObject(appState)
        }
    }
}

// MARK: - AppDelegate 支援 UIApplicationDelegate
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
      }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
}

// MARK: - AppState 控制登入登出狀態

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



