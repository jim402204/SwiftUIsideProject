//
//  BulletinViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import RxSwift
import SwiftUI

class BulletinViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    @Published var list: [BulletinCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        
        let api1 = apiService.request(FeatureApi.NewsList(top: .置頂))
        let api2 = apiService.request(FeatureApi.NewsList(top: .一般))
        
        Single.zip(api1, api2)
            .subscribe(onSuccess: { [weak self] re1,re2 in
                    
                guard let self = self else { return }
                
                let models = re1.result + re2.result
                self.list = models.map { BulletinCellViewModel($0) }
                
            }).disposed(by: disposeBag)
        
    }
    
}

class BulletinCellViewModel {
    let id: String
    let type: String
    let title: String
    let date: String
    let content: String
    let isTop: Bool
    
    init (_ model: NewContainerModel.NewModel) {
        self.id = model.id
        self.type = model.type
        self.title = model.title
        self.date = String(DateUtils.formatISO8601Date(model.create).prefix(10))
        self.content = model.desc
        self.isTop = model.top ?? false
    }
    
    init (type: String, title: String, date: String, content: String, isTop: Bool) {
        
        self.id = "0"
        self.type = type
        self.title = title
        self.date = String(DateUtils.formatISO8601Date(date).prefix(10))
        self.content = content
        self.isTop = isTop
    }
}
