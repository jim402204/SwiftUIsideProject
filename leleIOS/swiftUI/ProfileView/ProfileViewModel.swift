//
//  ProfileViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/4.
//
import SwiftUI
import RxSwift

class ProfileViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
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
        appState?.isLoggedIn = false
    }
}

extension ProfileViewModel {
    
    func callAPI() {
        
        let api1 = apiService.request(LaunchApi.UserInfo())
        let api2 = apiService.request(LaunchApi.HouseholdList())
        
        Single.zip(api1, api2)
            .subscribe(onSuccess: { [weak self] re1,re2 in
                    
                guard let self = self else { return }
                
                self.userName = re1.name
                self.accountID = re1.accountID
                
                if let model = re2.first {
                    self.shortAddress = model.community.city + " " + model.community.district
                    self.building =  model.building + model.doorPlate + model.floor
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func deviceInfoAPI() {
        
        apiService.request(LaunchApi.DeviceInfo())
            .subscribe(onSuccess: { [weak self] model in
                
                guard let self = self else { return }
                
                
            })
            .disposed(by: disposeBag)
    }
    
    func pointAPI() {
        
        apiService.request(NotifyApi.Point())
            .subscribe(onSuccess: { [weak self] model in
                
                guard let self = self else { return }
                
                self.point = "\(model.total)"
            })
            .disposed(by: disposeBag)
    }
    
}
