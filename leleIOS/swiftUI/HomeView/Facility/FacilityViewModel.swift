//
//  FacilityViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/17.
//

import Observation
import Foundation

@Observable
class FacilityViewModel {
    var list: [FacilityCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        Task {
            guard let model = try? await apiService.requestA(PublicFacilitiesApi.FacilityList()) else { return }
            
            let models = model.map { FacilityCellViewModel(model: $0) }
            
            await MainActor.run {
                self.list = models
            }
        }
    }
    
}

class FacilityCellViewModel {
    let id: String
    let name: String
    let tagText: String
    let imageUrl: URL?
    let enableTimeLabel: String
    
    init (model: FacilityModel) {
        self.id = model.id
        self.name = model.name
        self.tagText = model.type.desc
        
        let filepath = model.photo?.first ?? ""
        let photo = URLBuilder(imageApiDomain: imageApiDomain).buildURL(id: model.id, filepath: filepath)
        self.imageUrl = photo
        
        let text = model.enableTime.removingDuplicateWeekdays().compactMap { weekdayMapping[$0.weekday] }.joined(separator: "、")
        self.enableTimeLabel = text
    }
    
    init (id: String, name: String, tagText: String, imageUrl: URL?, enableTimeLabel: String) {
        self.id = UUID().uuidString
        self.name = name
        self.tagText = tagText
        self.imageUrl = imageUrl
        self.enableTimeLabel = enableTimeLabel
    }
    
}

extension Array where Element == FacilityModel.EnableTime {
    // 針對FacilityModel.EnableTime 去重
    func removingDuplicateWeekdays() -> [FacilityModel.EnableTime] {
        var seenWeekdays = Set<Int>()
        return self.reduce(into: []) { result, element in
            if !seenWeekdays.contains(element.weekday) {
                result.append(element)
                seenWeekdays.insert(element.weekday)
            }
        }
    }
}


let weekdayMapping: [Int: String] = [
    0: "周日",
    1: "周一",
    2: "周二",
    3: "周三",
    4: "周四",
    5: "周五",
    6: "周六"
]
