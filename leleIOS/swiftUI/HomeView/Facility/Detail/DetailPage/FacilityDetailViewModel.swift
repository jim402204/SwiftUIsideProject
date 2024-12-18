//
//  FacilityDetailViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import Foundation
import Observation

@Observable
class FacilityDetailViewModel {
    var list: [String] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        Task {
            guard let model = try? await apiService.requestA(PublicFacilitiesApi.FacilityBookingList(status: .歷史紀錄)) else { return }
            
            await MainActor.run {
//                self.list = model
            }
        }
    }
    
}
