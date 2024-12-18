//
//  FacilityReservationViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import Foundation
import Observation

@Observable
class FacilityReservationViewModel {
    var list: [FacilityBookingCellViewＭodel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        Task {
            guard let model = try? await apiService.requestA(PublicFacilitiesApi.FacilityBookingList(status: .預約資訊)) else { return }
            
            let models = model.map { FacilityBookingCellViewＭodel(model: $0,isHideCancelTag: false) }
            
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}

class FacilityBookingCellViewＭodel {
    let id: String
    let name: String
    let date: String
    let point: String
    let bookingCount: String
    let cancelTag: String = "取消預約"
    var isHideCancelTag = true
    
    
    init(model: FacilityBookingＭodel, isHideCancelTag: Bool = true) {
        self.id = model.id
        self.name = model.facility.name
        
        let start = DateUtils.formatISO8601Date(model.bookingStartTime,from: "yyyy-MM-dd'T'HH:mm:ssZ",to: "HH:mm")
        let end = DateUtils.formatISO8601Date(model.bookingEndTime,from: "yyyy-MM-dd'T'HH:mm:ssZ",to: "HH:mm")
        self.date =  start + " - " + end
        
        self.point = "一般點數 \(model.point ?? 0)點"
        self.bookingCount = "預約\(model.bookingCount)人"
        self.isHideCancelTag = isHideCancelTag
    }
    
}
