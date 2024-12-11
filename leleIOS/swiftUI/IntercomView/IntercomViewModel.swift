//
//  IntercomViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import RxSwift
import SwiftUI

enum UserRole {
case 住戶
case 物管
case 商家
}

var userRole: UserRole = .住戶

class IntercomViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    @Published var selectedTab: FeatureApi.IntercomList.Status = .社區
    @Published var intercomList: [IntercomCellViewModel] = []
    
    let tabs = {
        var all = FeatureApi.IntercomList.Status.allCases.map { $0 }
        if userRole == .物管 {
            all = all.filter { $0 != .戶戶 }
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
            .subscribe(
                onSuccess: { [weak self] model in
                    
                    guard let self = self else { return }
                    
                    self.intercomList = model.map { IntercomCellViewModel($0, status: currentTab) }
                })
            .disposed(by: disposeBag)
        
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
