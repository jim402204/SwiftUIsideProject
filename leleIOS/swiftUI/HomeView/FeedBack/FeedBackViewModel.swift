//
//  FeedBackViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import Observation
import Foundation

@Observable
class FeedBackViewModel {
    
    var list: [FeedbackListModel] = []
    var selectedTab: PublicFacilitiesApi.FeedbackList.Status = .等待回覆
    let tabs = PublicFacilitiesApi.FeedbackList.Status.allCases.map { $0 }
    
    init() {
        callAPI()
    }
    
    func tabChanged(_ tab: PublicFacilitiesApi.FeedbackList.Status) {
        selectedTab = tab
        
        callAPI()
    }
    
    func callAPI() {
        
        let currentTab = PublicFacilitiesApi.FeedbackList.Status.allCases.first { $0 == selectedTab } ?? .等待回覆
        
        Task {
            guard let models = try? await apiService.requestA(PublicFacilitiesApi.FeedbackList(type: currentTab)) else { return }
        
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}

