//
//  ManageFeeViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import Observation
import Foundation

@Observable
class ManageFeeViewModel {
    enum Status: String, CaseIterable {
        case 當期
        case 前期
    }
    
    var list: [MgmtfeeInfoModel] = []
    var selectedTab: ManageFeeViewModel.Status = .當期
    let tabs = ManageFeeViewModel.Status.allCases.map { $0 }
    
    init() {
        callAPI()
    }
    
    func tabChanged(_ tab: ManageFeeViewModel.Status) {
        selectedTab = tab
        
        switch tab {
        case .當期:
            callAPI()
        case .前期:
            callhistoryAPI()
        }
    }
    
    func callAPI() {
        
        Task {
            guard let models = try? await apiService.requestA(FeatureApi.MgmtfeeInfo()) else { return }
        
            await MainActor.run {
                self.list = models
            }
        }
    }
    
    func callhistoryAPI() {
        
        Task {
            guard let models = try? await apiService.requestA(FeatureApi.MgmtfeeHistory()) else { return }
        
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}
