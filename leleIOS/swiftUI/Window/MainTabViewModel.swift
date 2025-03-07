//
//  MainTabViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//

import SwiftUI
import Combine
import FirebaseMessaging

class MainTabViewModel: ObservableObject {
    
    @Published var isCommunityOpening: Bool = false
    
    init () {
        householdListAPI()
        
        callUserInfo()
        
        getFCMTokenAndCallDeviceAPI()
        
        binding()
    }
    
    func binding() {
        
        CommunityBindingState.shared.$isOpening
            .receive(on: RunLoop.main)
            .assign(to: &$isCommunityOpening)
    }
    /// 前提是登入了
    func getFCMTokenAndCallDeviceAPI() {
        //等待firebase api回來 才有內容 不然會在 firebase call api之前就檢查了
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                    self.callDeviceInfo(fcmToken: "")
                } else if let token = token {
                    print("uploading FCM token: \(token)")
                    self.callDeviceInfo(fcmToken: token)
                }
            }
        }
    }
    
    func householdListAPI() {
        
        Task {
            do {
                let respone = try await apiService.requestA(LaunchApi.HouseholdList())
                
                guard let model = respone.first else {
                    CommunityBindingState.shared.reset()
                    return
                }
                CommunityBindingState.shared.saveCommunityInfo(model: model)
                
            } catch {
                print("HouseholdList: error: \(error)")
            }
        }
        
    }
    
    func callUserInfo() {
        
        Task {
            
            do {
                let model = try await apiService.requestA(LaunchApi.UserInfo())
                
                guard let cid = model.communityAdmin?.first else { return  }
                let hid = model.defaultHouseHold ?? ""
                
                UserDefaultsHelper.userIdInfo = UserIDInfo(uid: model.id, cid: cid, hid: hid)
                
            } catch {
                print("UserInfo: error: \(error)")
            }
        }
    }
    
    func callDeviceInfo(fcmToken: String) {
        
        Task {
            do {
                let model = try await apiService.requestA(LaunchApi.DeviceInfo(fcmToken: fcmToken))
                UserDefaultsHelper.deviceID = model.ID
                
            } catch {
                print("UserInfo: error: \(error)")
            }
        }
    }
    
    /// 測試多筆api可能閃退的問題
    func testError() {
        
        for i in 1...100 {
            print("Starting callUserInfo for iteration \(i)")
            Task {
                do {
                    let model = try await apiService.requestA(LaunchApi.UserInfo())
                    print("Iteration \(i) succeeded: \(model)")
                    
                    guard let cid = model.communityAdmin?.first else { return }
                    let hid = model.defaultHouseHold ?? ""
                    
                    DispatchQueue.main.async {
                        UserDefaultsHelper.userIdInfo = UserIDInfo(uid: model.id, cid: cid, hid: hid)
                    }
                } catch {
                    print("Iteration \(i) failed with error: \(error)")
                }
            }
        }
    }
    
}

// MARK: - 快速login API 測試用
/// 給測試用
func loginAPI(bag: inout Set<AnyCancellable>, handle: (()->())? = nil) {
    
    apiService.request(UserApi.GetToken())
        .cFlatMapLatest { model in
            let token = model.Token
            let user = "0987654321"
            let pass = "135246"
            let digest = generateSHA256Digest(user: user, token: token, pass: pass)

            return apiService.request(UserApi.Login(user: user, digest: digest, token: token))
        }.sink { model in
            
            UserDefaultsHelper.token = model.jwtToken
            
            handle?()
            
        }.store(in: &bag)
}

import CryptoKit

func generateSHA256Digest(user: String, token: String, pass: String) -> String {
    // 1. 組合字串
    let combinedString = "\(user):\(token):\(pass)"
    print("Combined String: \(combinedString)") // 可用於調試

    // 2. 將字串轉換為 Data（UTF-8 編碼）
    guard let data = combinedString.data(using: .utf8) else {
        print("Error: Unable to convert string to data")
        return ""
    }

    // 3. 使用 SHA256 加密
    let hashed = SHA256.hash(data: data)

    // 4. 將加密結果轉換為十六進制字串
    let digest = hashed.compactMap { String(format: "%02x", $0) }.joined()
    
    print("SHA256 Digest: \(digest)") // 可用於調試
    return digest
}

// MARK: - 給Preview用的賽login token 測試用

struct PreviewTokenView<Content: View>: View {
    let content: Content

    init(content: @escaping () -> Content) {
        // 在 Preview 中初始化前执行所需操作
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            UserDefaultsHelper.token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzQ1MDc2NzgsInN1YiI6IjYzYmNkMWI3Y2I1ZWU0ZmVlYzBiMmEwZSJ9.AAWF0fPCrczNr2MtoZtbTXsRdoLdxHAotuk78s8cSaj9HZl1fJt_cxzKlHGasfTikf7a0britNibLSG6oi5zLg"
        }
        #endif
        self.content = content()
    }

    var body: some View {
        content
    }
}
