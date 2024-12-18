//
//  GasViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import Observation
import Foundation

@Observable
class GasViewModel {
    
    var model: GasHistoryModel? = nil
    var list: [GasHistoryModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        Task {
            guard let models = try? await apiService.requestA(FeatureApi.GasHistory()) else { return }
        
            await MainActor.run {
                self.list = models
                self.model = models.first
            }
        }
    }
    
}
