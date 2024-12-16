//
//  RuleViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import Combine
import SwiftUI

class RuleViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var list: [BulletinCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        
        apiService.requestC(PublicFacilitiesApi.RulesList())
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                let models: [RulesListModel] = model
                self.list = models.map { BulletinCellViewModel($0) }
                
            }).store(in: &bag)
    }
    
}
