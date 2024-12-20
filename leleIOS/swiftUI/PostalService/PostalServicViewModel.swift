//
//  PostalServicViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import Combine
import SwiftUI

class PostalServicViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    @Published var selectedTab: FeatureApi.PackageList.Status = .未領取
    @Published var list: [PostalServiceCellViewModel] = []
    
    let tabs = FeatureApi.PackageList.Status.allCases.map { $0 }
    
    func tabChanged(_ tab: FeatureApi.PackageList.Status) {
        selectedTab = tab
        callAPI()
    }
    
    func callAPI() {
        
        if UserDefaultsHelper.userRole == .住戶 {
            packageListAPI()
        } else if UserDefaultsHelper.userRole == .物管 {
            managePackageListAPI()
        }
    }
    
    func packageListAPI() {
        
        let currentTab = FeatureApi.PackageList.Status.allCases.first { $0 == selectedTab } ?? .未領取
        
        apiService.request(FeatureApi.PackageList(status: currentTab))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                let models = model.map { PostalServiceCellViewModel(model: $0,type: self.selectedTab) }
                self.list = models
                
            }).store(in: &bag)
        
    }
    
    func managePackageListAPI() {
        
        let currentTab = FeatureApi.PackageList.Status.allCases.first { $0 == selectedTab } ?? .未領取
        
        apiService.request(FeatureApi.MPackageList(status: currentTab))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                let models = model.map { PostalServiceCellViewModel(model: $0,type: self.selectedTab) }
                self.list = models
                
            }).store(in: &bag)
        
    }
    
}
