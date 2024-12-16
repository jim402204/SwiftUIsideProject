//
//  SecurityControlViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import Combine
import SwiftUI

class SecurityControlViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    
    @Published var list: [MediaListModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        apiService.requestC(FeatureApi.MediaList())
            .sink(onSuccess: { [weak self] model in
                guard let self = self else { return }
                
                self.list = model
                
            }).store(in: &bag)
        
    }
}
