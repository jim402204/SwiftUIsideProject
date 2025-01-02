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
    @Published var allList: [FeatureApi.IntercomList.Status:[IntercomCellViewModel]] = [:]
    
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
    
    init () { binding() }
    
    // 监听 selectedTab 的变化并触发 API 请求
    private func binding() {
        $selectedTab
            .removeDuplicates()
            .print("$selectedTab")
            .sink { [weak self] tab in
                self?.loadTabDataIfNeeded(for: tab)
            }
            .store(in: &bag)
    }
    
    // 加载数据，仅当该 Tab 的数据未加载时触发 API
    private func loadTabDataIfNeeded(for tab: FeatureApi.IntercomList.Status) {
        guard allList[tab] == nil else { return } // 如果已有数据，直接返回
        
        intercomListAPI(tab)
    }
    
    func callAPI() {
        intercomListAPI(self.selectedTab)
    }
    
    func intercomListAPI(_ tabType: FeatureApi.IntercomList.Status) {

        apiService.request(FeatureApi.IntercomList(status: tabType))
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
            
                var viewModels = model.map { IntercomCellViewModel($0, status: tabType) }
                
                if tabType == .社區, UserDefaultsHelper.userRole == .住戶 {
                    viewModels = viewModels.filter { $0.name == "管理中心" }
                }
                self.allList[tabType] = viewModels
                
            }).store(in: &bag)
    }
}

class IntercomCellViewModel: Identifiable {
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
