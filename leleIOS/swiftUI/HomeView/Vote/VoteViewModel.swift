//
//  VoteViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import Observation
import Foundation

@Observable
class VoteViewModel {
    var list: [VoteListModel] = []
   
    init() {
        callAPI()
    }
    
    
    func callAPI() {
        
        Task {
            guard let models = try? await apiService.requestA(PublicFacilitiesApi.VoteList()) else { return }
            
            await MainActor.run {
                self.list = models
            }
        }
    }
}
