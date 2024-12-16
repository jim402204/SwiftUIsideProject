//
//  MainTabViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//

import SwiftUI
import Combine

class MainTabViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    init () {
        callAPI()
    }
    
    func callAPI() {
        
        apiService.request(LaunchApi.HouseholdList())
            .sink(onSuccess: { [weak self] respone in
                guard let self = self else { return }
                
                guard let model = respone.first else { return }
                
                let userInfo = CommunityInfo(
                    id: model.community.id,
                    name: model.community.name,
                    building: model.building,
                    doorPlate: model.doorPlate,
                    floor: model.floor
                )
                
                UserDefaultsHelper.communityAdmin = model.community.id
                UserDefaultsHelper.userBuilding = userInfo
                
            }).store(in: &bag)
        
    }
    
}

// MARK: - 快速login API 測試用
/// 給測試用
func loginAPI(bag: inout Set<AnyCancellable>, handle: (()->())? = nil) {
    
    apiService.request(UserApi.GetToken())
        .flatMapLatest { model in
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
            UserDefaultsHelper.token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzQ0MDQzMzMsInN1YiI6IjYzYmNkMWI3Y2I1ZWU0ZmVlYzBiMmEwZSJ9.FuZeI5z7wQ_H1sMV-h27gu2e-WEF7MKVFl49n_Id1EQWtvI0ViUg-hvonnaELf_upkcaAZi_VmGWMMD80xIuHQ"
        }
        #endif
        self.content = content()
    }

    var body: some View {
        content
    }
}
