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
    @Published var allList: [FeatureApi.PackageList.Status:[PostalServiceCellViewModel]] = [:]
    
    let tabs = FeatureApi.PackageList.Status.allCases.map { $0 }
    
    init () { binding() }
    
    // 监听 selectedTab 的变化并触发 API 请求
    private func binding() {
        $selectedTab
            .removeDuplicates()
            .print("$selectedTab")
            .sink { [weak self ] tab in
                // 延遲讓selectedTab (直接取用還沒變) 更新在call api
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self?.callAPI()
                    print("selectedTab: \(String(describing: self?.selectedTab))\ntab: \(tab)")
                }
                print("selectedTab: \(String(describing: self?.selectedTab))\ntab: \(tab)")
            }
            .store(in: &bag)
    }
    
    func callAPI() {
        
        if UserDefaultsHelper.userRole == .住戶 {
            packageListAPI()
        } else if UserDefaultsHelper.userRole == .物管 {
            managePackageListAPI()
        }
    }
    
    func packageListAPI() {
        
        apiService.request(FeatureApi.PackageList(status: selectedTab))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                let models = model.map { PostalServiceCellViewModel(model: $0,type: self.selectedTab) }
                self.allList[selectedTab] = models
                
                print("models count: \(models.count)")
                
            }).store(in: &bag)
        
    }
    
    func managePackageListAPI() {
        
        apiService.request(FeatureApi.MPackageList(status: selectedTab))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                let models = model.result.map { PostalServiceCellViewModel(model: $0,type: self.selectedTab) }
                self.allList[selectedTab] = models
                
            }).store(in: &bag)
        
    }
    
}
