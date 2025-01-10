//
//  BulletinViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import Combine
import SwiftUI
import Observation

@Observable
class BulletinViewModel {
    private var bag = Set<AnyCancellable>()
    
    var list: [BulletinCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        let api1 = apiService.request(FeatureApi.NewsList(top: .置頂))
        let api2 = apiService.request(FeatureApi.NewsList(top: .一般))
        
        Publishers.Zip(api1, api2)
            .sink(onSuccess: { [weak self] re1, re2 in
                guard let self = self else { return }
                
                let models = re1.result + re2.result
                self.list = models.map { BulletinCellViewModel($0) }
                
            }).store(in: &bag)
    }
    
    
    func callAsyncAPI() {
        
        Task {
            do {
                async let model1 = apiService.requestA(FeatureApi.NewsList(top: .置頂))
                async let model2 = apiService.requestA(FeatureApi.NewsList(top: .一般))
                
                // 等待两个请求的结果
                let result1 = try await model1.result
                let result2 = try await model2.result
                let combineResults = result1 + result2
                let viewModels = combineResults.map { BulletinCellViewModel($0) }
                
                await MainActor.run {
                    self.list = viewModels
                }
            } catch {
                print(error)
            }
        }
    }
    
}

class BulletinCellViewModel {
    let id: String
    let type: String
    let title: String
    let date: String
    let content: String
    let isTop: Bool
    // 規章用
    var updateDate: String? = nil
    // app 不能用要Date
    // 附件
    var files: [URL] = []
    // 圖片
    var images: [URL] = []
    
    init (_ model: NewContainerModel.NewModel) {
        self.id = model.id
        self.type = model.type
        self.title = model.title
        self.date = String(DateUtils.formatISO8601Date(model.create).prefix(10))
        self.content = model.desc ?? ""
        self.isTop = model.top ?? false
        
        let urls = model.image?.compactMap({ filepath in
            URLBuilder().buildGoURL(filepath: filepath)
        }) ?? []
        self.images = urls
        
        let files: [URL] = model.file?.compactMap({ filepath in
            let url = URLBuilder().buildGoURL(supportDocsViewer: true, filepath: filepath)
            return url
        }) ?? []
        self.files = files
    }
    
    init (type: String, title: String, date: String, content: String, isTop: Bool) {
        
        self.id = "0"
        self.type = type
        self.title = title
        self.date = String(DateUtils.formatISO8601Date(date).prefix(10))
        self.content = content
        self.isTop = isTop
    }
    
    /// 規章
    init (_ model: RulesListModel) {
        
        self.id = model.id
        self.type = model.type
        self.title = model.title
        self.date = String(DateUtils.formatISO8601Date(model.create).prefix(10))
        self.content = "規約附件"
        self.isTop = false
        self.updateDate = String(DateUtils.formatISO8601Date(model.update ?? "").prefix(10))
    }
    
    /// 原本要提供給外部的
    func openURL(_ url: URL) {
        print("openURL: \(url)")
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
