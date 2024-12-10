//
//  RuleViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import RxSwift
import SwiftUI

class RuleViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    @Published var list: [BulletinCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        
        apiService.request(PublicFacilitiesApi.RulesList())
            .subscribe(onSuccess: { [weak self] model in
                    
                guard let self = self else { return }
                
                let models: [RulesListModel] = model
                self.list = models.map { BulletinCellViewModel($0) }
                
            }).disposed(by: disposeBag)
        
    }
    
}
