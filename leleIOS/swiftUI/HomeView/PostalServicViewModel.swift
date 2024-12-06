//
//  PostalServicViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import RxSwift
import SwiftUI

class PostalServicViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    @Published var selectedTab: FeatureApi.PackageList.Status = .未領取
    @Published var list: [PackageModel] = []
    
    let tabs = FeatureApi.PackageList.Status.allCases.map { $0 }
    
    func tabChanged(_ tab: FeatureApi.PackageList.Status) {
        selectedTab = tab
        intercomListAPI()
    }
    
    func callAPI() {
        
        loginAPI(bag: disposeBag) {
            
            self.intercomListAPI()
        }
    }
    
    func intercomListAPI() {
        
        let currentTab = FeatureApi.PackageList.Status.allCases.first { $0 == selectedTab } ?? .未領取
        
        apiService.request(FeatureApi.PackageList(status: currentTab))
            .subscribe(
                onSuccess: { [weak self] model in
                    
                    guard let self = self else { return }
                    
//                    let newModel: [IdentifiableModel<PackageModel>] = model.map { IdentifiableModel(model: $0) }
                    self.list = model
                })
            .disposed(by: disposeBag)
        
    }
}
