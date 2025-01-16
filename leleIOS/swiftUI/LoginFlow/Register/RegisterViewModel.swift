import SwiftUI
import Combine
import CombineExt

class RegisterViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    @Published var realName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isValidButtonEnable: Bool = false
    @Published var isRegisterButtonEnable: Bool = false
    
    var registerColor: Color { isRegisterButtonEnable ? Color.teal : .init(uiColor: .systemGray2) }
    
    init() {
        binging()
    }
    
    func binging() {
        
        $phoneNumber
            .map { $0.count >= 10 }
            .receive(on: RunLoop.main)
            .assign(to: \.isValidButtonEnable, on: self)
            .store(in: &bag)
        
        
        [
            $realName.map { !$0.isEmpty },
            $email.map { !$0.isEmpty },
            $phoneNumber.map { !$0.isEmpty },
            $verificationCode.map { !$0.isEmpty },
            $password.map { !$0.isEmpty },
            $confirmPassword.map { !$0.isEmpty }
        ]
            .combineLatest() // CombineExt 提供的扩展方法
            .map { values -> Bool in
                let allFieldsFilled = values.allSatisfy { $0 }
                let passwordsMatch = self.password == self.confirmPassword
                let isPhoneNumber = self.phoneNumber.count >= 10
                
                return allFieldsFilled && passwordsMatch && isPhoneNumber
            }
            .removeDuplicates()
            .assign(to: &$isRegisterButtonEnable)
        
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
