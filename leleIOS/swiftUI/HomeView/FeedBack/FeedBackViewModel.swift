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
        
        Task {
            guard let models = try? await apiService.requestA(PublicFacilitiesApi.FeedbackList(type: selectedTab)) else { return }
        
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}

