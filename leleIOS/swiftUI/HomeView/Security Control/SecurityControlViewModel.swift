//
//  SecurityControlViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import RxSwift
import SwiftUI

class SecurityControlViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    @Published var list: [MediaListModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        apiService.request(FeatureApi.MediaList())
            .subscribe(
                onSuccess: { [weak self] model in
                    
                    guard let self = self else { return }
                    
                    self.list = model
                })
            .disposed(by: disposeBag)
        
    }
}
