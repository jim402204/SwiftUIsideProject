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
    
    @Published var userName: String = ""
    @Published var accountID: String = ""
    
    @Published var shortAddress: String = ""
    @Published var building: String = ""
    @Published var point: String = "0"
    
    @Published var receiveNotifications = true
    /// 社區開通
    @Published var isCommunityOpening = false
    
    private var appState: AppState?

    
    init () {
        callAPI()
        binding()
    }
    
    func binding() {
        
        CommunityBindingState.shared.$isOpening
            .receive(on: RunLoop.main)
            .assign(to: &$isCommunityOpening)
    }
    
    func setAppState(_ appState: AppState) {
        self.appState = appState
    }
    
    func logout() {
//        appState?.logOut()

        CommunityBindingState.shared.isOpening.toggle()
    }
}

extension ProfileViewModel {

    func callAPI() {
        
        let api1 = apiService.request(LaunchApi.UserInfo())
        let api2 = apiService.request(LaunchApi.HouseholdList())
        
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
    
    func pointAPI() {
        
        guard isCommunityOpening else { return }
        
        apiService.request(NotifyApi.Point())
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                self.point = "\(model.total)"
                
            }).store(in: &bag)
    }
    
    func logoutAPI() {
        
        guard let uid = UserDefaultsHelper.deviceID else { return }
        
        apiService.request(UserApi.Logout(uid: uid))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                
            }).store(in: &bag)
    }
    
}

