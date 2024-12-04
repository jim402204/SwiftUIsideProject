import SwiftUI
import RxSwift
import Moya
import CryptoKit

class NotificationViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    @Published var selectedTab: NotifyApi.NotificationList.Status = .全部
    @Published var notifications: [NotificationModel] = []
    
    let tabs = NotifyApi.NotificationList.Status.allCases.map { $0 }
    
//    init() 不能放置binding 可能重複呼叫 StateObject的話 只有一次 不算preview
    
    func tabChanged(to tab: NotifyApi.NotificationList.Status) {
        selectedTab = tab
        notificationListAPI()
    }
    
    func callAPI() {
        
        loginAPI {
            self.notificationListAPI()
        }
    }
    
}

extension NotificationViewModel {
    
    private func notificationListAPI() {
        let currentTab = NotifyApi.NotificationList.Status.allCases.first { $0 == selectedTab } ?? .全部
        
        apiService.request(NotifyApi.NotificationList(s: currentTab))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (models: [NotificationModel]) in
                
                self?.notifications = models
            })
            .disposed(by: disposeBag)
    }
    
    private func loginAPI(handle: (()->())? = nil) {
        
        apiService.request(UserApi.GetToken()).asObservable()
            .flatMapLatest({ [unowned self] model in
                
                let token = model.Token
                let user = "0987654321"
                let pass = "135246"
                let digest = self.generateSHA256Digest(user: user, token: token, pass: pass)
                
                return apiService.request(UserApi.Login(user: user, digest: digest, token: token))
            })
            .subscribe { model in
                
                UserDefaultsHelper.token = model.jwtToken
                
                handle?()
                
            }.disposed(by: disposeBag)
    }
    
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
    
}
