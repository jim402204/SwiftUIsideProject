import SwiftUI
import Combine

class RegisterViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    @Published var realName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isValidButtonEnable: Bool = false
    
    init() {
        binging()
    }
    
    func binging() {
        
        $phoneNumber
            .map { $0.count >= 10 }
            .receive(on: RunLoop.main)
            .assign(to: \.isValidButtonEnable, on: self)
            .store(in: &bag)
        
        $phoneNumber
            .scan("") { _, newValue in
                let filtered = String(newValue.prefix(10)) // 截断超出长度的字符
                return filtered
            }
            .removeDuplicates()
            .receive(on: RunLoop.main) // 确保在主线程更新
            .sink { [unowned self] in self.phoneNumber = $0 }
            .store(in: &bag)
        
    }
    
    func getVerificationCode() {
        
        apiService.requestRaw(LaunchApi.SendSms(phone: phoneNumber))
            .sink(onSuccess: { _ in
                
            }).store(in: &bag)
    }
    
    func registerAPI() {
        
        apiService.requestRaw(
            LaunchApi.Register(
                account: phoneNumber,
                name: realName,
                email: email,
                password: password,
                smsCode: verificationCode
            )
        )
        .sink(onSuccess: { [weak self] model in
            guard let self = self else { return }
            
            
        }).store(in: &bag)
        
    }
} 
