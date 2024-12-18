//
//  LoginRecordViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import Observation
import Foundation

@Observable
class LoginRecordViewModel {
    var list: [LoginDeviceListModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        Task {
            guard let models = try? await apiService.requestA(UserApi.LoginDeviceList()) else { return }
        
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}
