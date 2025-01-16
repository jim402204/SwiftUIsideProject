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
import UserNotifications
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        // 設定通知
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("通知授權失敗：\(error)")
            }
        }
        application.registerForRemoteNotifications()
                
        
        return true
      }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    // 註冊設備 Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("遠程通知註冊失敗：\(error)")
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



