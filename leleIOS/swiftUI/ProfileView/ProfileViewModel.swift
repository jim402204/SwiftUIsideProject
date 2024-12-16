//
//  ProfileViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    @Published var userName: String = "User"
    @Published var accountID: String = "User phone"
    @Published var shortAddress: String = ""
    @Published var building: String = ""
    @Published var point: String = "0"
    
    @Published var receiveNotifications = true
    
    // navigation To VC
//    @Published var pushToProfile: Bool = false
//    @Published var pushToChangePassword: Bool = false
//    @Published var pushToLoggedDevices: Bool = false
//    @Published var pushToCommunity: Bool = false
//    @Published var pushToPointsManagement: Bool = false
    
    private var appState: AppState?

    
    init () {
        callAPI()
    }
    
    func setAppState(_ appState: AppState) {
        self.appState = appState
    }
    
    func logout() {
        appState?.logOut()
    }
}

extension ProfileViewModel {

    func callAPI() {
        
        let api1 = apiService.requestC(LaunchApi.UserInfo())
        let api2 = apiService.requestC(LaunchApi.HouseholdList())
        
        Publishers.Zip(api1, api2)
            .sink(onSuccess: { [weak self] re1, re2 in
                guard let self = self else { return }
                
                // 更新用户信息
                self.userName = re1.name
                self.accountID = re1.accountID
                
                if let model = re2.first {
                    self.shortAddress = model.community.city + " " + model.community.district
                    self.building = model.building + model.doorPlate + model.floor
                }
            }).store(in: &bag)
    }
    
    func deviceInfoAPI() {
        
        apiService.requestC(LaunchApi.DeviceInfo())
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                
            }).store(in: &bag)
    }
    
    func pointAPI() {
        
        apiService.requestC(NotifyApi.Point())
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                self.point = "\(model.total)"
                
            }).store(in: &bag)
    }
    
    func logoutAPI() {
        
        apiService.requestC(UserApi.Logout(uid: "uid"))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                
            }).store(in: &bag)
    }
    
}

