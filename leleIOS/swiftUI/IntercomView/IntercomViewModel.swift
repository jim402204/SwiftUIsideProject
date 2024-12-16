//
//  IntercomViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import Combine
import SwiftUI

class IntercomViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var selectedTab: FeatureApi.IntercomList.Status = .社區
    @Published var intercomList: [IntercomCellViewModel] = []
    
    var titleMapping: [FeatureApi.IntercomList.Status : String] {
        var type: [FeatureApi.IntercomList.Status : String] = [:]
        if UserDefaultsHelper.userRole == .物管 {
            type = [.戶戶 : "住戶"]
        }
        return type
    }
    let tabs = {
        var all = FeatureApi.IntercomList.Status.allCases.map { $0 }
        if UserDefaultsHelper.userRole == .物管 {
            all = [.社區, .戶戶]
        }
        return all
    }()
    
    func tabChanged(_ tab: FeatureApi.IntercomList.Status) {
        selectedTab = tab
        intercomListAPI()
    }
    
    func callAPI() {
        
//        loginAPI(bag: disposeBag) {
            
            self.intercomListAPI()
//        }
    }
    
    func intercomListAPI() {
        
        let currentTab = FeatureApi.IntercomList.Status.allCases.first { $0 == selectedTab } ?? .社區
        
        apiService.request(FeatureApi.IntercomList(status: currentTab))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
            
                var viewModels = model.map { IntercomCellViewModel($0, status: currentTab) }
                
                if selectedTab == .社區, UserDefaultsHelper.userRole == .住戶 {
                    viewModels = viewModels.filter { $0.name == "管理中心" }
                }
                
                self.intercomList = viewModels
                
            }).store(in: &bag)
            
        
    }
}

class IntercomCellViewModel {
    let id: String
    let name: String
    var isEnable: Bool = false
    let status: FeatureApi.IntercomList.Status
    
    init (_ model: IntercomListModel, status: FeatureApi.IntercomList.Status) {
        self.id = model.id
        self.status = status
        
        if status == .戶戶 {
            self.name = (model.building ?? "") + (model.doorPlate ?? "") + (model.floor ?? "")
            self.isEnable = true
        } else {
            self.name = model.name ?? ""
            self.isEnable = model.canDial ?? true
        }
    }
}
