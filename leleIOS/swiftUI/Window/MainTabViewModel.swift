//
//  MainTabViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//

import SwiftUI
import RxSwift

class MainTabViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    init () {
        callAPI()
    }
    
    func callAPI() {
        
        apiService.request(LaunchApi.HouseholdList())
            .subscribe(
                onSuccess: { [weak self] respone in
                    
                    guard let self = self else { return }
                    guard let model = respone.first else { return }
                    
                    let userInfo = CommunityInfo(
                        building: model.building,
                        doorPlate: model.doorPlate,
                        floor: model.floor
                    )
                
                UserDefaultsHelper.userBuilding = userInfo
            })
            .disposed(by: disposeBag)
        
    }
    
}


/// 給測試用
func loginAPI(bag: DisposeBag, handle: (()->())? = nil) {
    
    apiService.request(UserApi.GetToken()).asObservable()
        .flatMapLatest({ model in
            
            let token = model.Token
            let user = "0987654321"
            let pass = "135246"
            let digest = generateSHA256Digest(user: user, token: token, pass: pass)
            
            return apiService.request(UserApi.Login(user: user, digest: digest, token: token))
        })
        .subscribe { model in
            
            UserDefaultsHelper.token = model.jwtToken
            
            handle?()
            
        }.disposed(by: bag)
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
