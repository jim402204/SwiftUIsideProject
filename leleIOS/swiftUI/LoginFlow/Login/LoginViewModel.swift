import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
//    @Published var phoneNumber: String = "0987654321"
//    @Published var password: String = "135246"
    
    @Published var phoneNumber: String = "0920217338"
    @Published var password: String = "402204jim"
    
    @Published var isPasswordVisible: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // navigate To VC
    @Published var pushToRegister: Bool = false
    @Published var pushToForgotPassword: Bool = false
    
    private var appState: AppState? = nil
    
    // 驗證手機號碼格式
    var isPhoneNumberValid: Bool {
        let phoneRegex = "^09\\d{8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    // 驗證密碼格式
    var isPasswordValid: Bool {
        return password.count >= 6
    }
    
    // 登入功能
    func login() {
        guard isPhoneNumberValid else {
            showError = true
            errorMessage = "請輸入正確的手機號碼格式"
            return
        }
        
        guard isPasswordValid else {
            showError = true
            errorMessage = "密碼長度必須至少6位"
            return
        }
        
        loginAPI()
    }
    
    func setApp(state: AppState) {
        self.appState = state
    }
    
    
    // 處理忘記密碼
    func handleForgotPassword() {
        pushToForgotPassword = true
    }
    
    // 處理註冊
    func handleRegister() {
        pushToRegister = true
    }
} 

import CryptoKit

extension LoginViewModel {
    
    private func loginAPI(handle: (()->())? = nil) {
        
        isLoading = true
        
        apiService.request(UserApi.GetToken())
            .flatMapLatest { [unowned self] model in
                let token = model.Token
                let user = phoneNumber
                let pass = password
                let digest = self.generateSHA256Digest(user: user, token: token, pass: pass)

                return apiService.request(UserApi.Login(user: user, digest: digest, token: token))
            }.sink(onSuccess: { [weak self] model in
                
                self?.appState?.logIn(token: model.jwtToken)
                handle?()
                
            }, onCompletion: { [weak self] in
                self?.isLoading = false
                
            }).store(in: &bag)
        
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
