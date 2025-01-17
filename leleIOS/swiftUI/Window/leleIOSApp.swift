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
        
        setFirebase()

        registerForRemoteNotifications(application)
        
//        simulateIncomingCall()
        
        return true
      }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    
}

//MARK: - 測試callkit
extension AppDelegate {
    //需要一直 hold住
    static var callHandler = CallHandler()
    
    /// 測試系統 callkit
    func simulateIncomingCall() {
        // 模擬來電
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Triggering simulated call...")
            AppDelegate.callHandler.simulateIncomingCall()
        }
    }
}

//MARK: - 推播設定 setting
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForRemoteNotifications(_ application: UIApplication) {
        
        // 設定通知
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("通知授權失敗：\(error)")
                return
            }
            
            if granted {
                print("授權成功")
            } else {
                print("用户未授予通知权限")
            }
        }
        /// 不論是否同意都註冊 firebase sdk會攔截
        /// didRegisterForRemoteNotificationsWithDeviceToken
        /// didFailToRegisterForRemoteNotificationsWithError
        application.registerForRemoteNotifications()
    }
    
    // 前景收到
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 取得推播內容
        let userInfo = notification.request.content.userInfo
        print("前景收到推播通知: \(userInfo)")
        
        // 指定要顯示的通知樣式 (如 .banner, .sound, .badge)
        completionHandler([.banner, .sound, .badge])
    }
    // 背景收到 點擊進去才算
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 取得推播內容
        let userInfo = response.notification.request.content.userInfo
        print("用戶點擊通知: \(userInfo)")
        
        // 根據推播內容執行特定邏輯 (例如導航到特定頁面)
        completionHandler()
    }
    
    // 直接從sdk 獲取token 不需要傳遞
    func getFCMToken() {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
    }
    
}


//MARK: - firebase refresh_token
extension AppDelegate: MessagingDelegate {
    /// set firebase for FCM => 推波
    func setFirebase() {

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase fcmToken: \(String(describing: fcmToken ?? ""))")
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



