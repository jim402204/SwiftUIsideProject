//
//  FacilityRecordViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import Foundation
import Observation

@Observable
class FacilityRecordViewModel {
    var list: [FacilityBookingCellViewＭodel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        Task {
            guard let model = try? await apiService.requestA(PublicFacilitiesApi.FacilityBookingList(status: .歷史紀錄)) else { return }
            
            let models = model.map { FacilityBookingCellViewＭodel(model: $0) }
            
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}
