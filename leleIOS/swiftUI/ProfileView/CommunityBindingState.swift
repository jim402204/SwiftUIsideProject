//
//  CommunityBindingState.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/15.
//

import Combine

// 處理社區資訊
/// 訊息存入 UserDefaultsHelper
/// isOpening用來綁定swiftUI
class CommunityBindingState: ObservableObject {
    static let shared = CommunityBindingState()
    /// 社區是否已經開通
    @Published var isOpening: Bool = false
    
    private init() {}
    
    /// 讀取UserDefaultsHelper buildingText
    func updateState() {
        isOpening = !UserDefaultsHelper.userBuilding.buildingText.isEmpty
    }
    
    func saveCommunityInfo(model: HouseholdListModel) {
        
        let userInfo = CommunityInfo(
            id: model.community.id,
            name: model.community.name,
            building: model.building,
            doorPlate: model.doorPlate,
            floor: model.floor
        )
        
        UserDefaultsHelper.communityAdmin = model.community.id
        UserDefaultsHelper.userBuilding = userInfo
        
        updateState()
    }
    /// 回歸未開通的社區狀態
    func reset() {
        
        UserDefaultsHelper.communityAdmin = ""
        UserDefaultsHelper.userBuilding = CommunityInfo()
        updateState()
    }
    
//    @Published var isCommunityOpening = false
//
//    func binding() {
//
//        CommunityBindingState.shared.$isOpening
//            .receive(on: RunLoop.main)
//            .assign(to: &$isCommunityOpening)
//    }
}
