//
//  GuestViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/11.
//
import SwiftUI
import Combine

class GuestViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var list: [GuestCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI1() {
        
        apiService.request(NotifyApi.GuestList())
            .sink { [weak self] model in
                guard let self = self else { return }
                
                let models = model.map { GuestCellViewModel(model: $0) }
                self.list = models
                
            }.store(in: &bag)
    }
    
    func callAPI() {
        
//        performAsyncOperation { try await apiService.requestA(NotifyApi.GuestList()) } onSuccess: { model in
//            let models = model.map { GuestCellViewModel(model: $0) }
//            self.list = models
//        }
        
        
        Task {
            do {
                let model = try await apiService.requestA(NotifyApi.GuestList())
                
                await MainActor.run {
                    let models = model.map { GuestCellViewModel(model: $0) }
                    self.list = models
                }
            } catch {
                print(error)
            }
        }
    }
    
}

class GuestCellViewModel {
    
    let imageUrl: URL?
    let visitTime: String
    let name: String
    let peopleCount: String
    let reason: String
    let company: String
    let leaveTime: String
    
    init (model: GuestListModel) {
        
        let filepath = model.webCamFileName ?? ""
        let imageUrl = URLBuilder(imageApiDomain: imageApiDomain).buildURL(id: model.id, filepath: filepath)
//        let imageUrl = URLBuilder().build1URL(filepath: filepath)
        
        self.imageUrl = imageUrl
        self.visitTime =  DateUtils.formatISO8601Date(model.visitTime)
        self.name = model.name ?? ""
        self.peopleCount = "\(model.peopleCount)"
        self.reason = model.reason
        self.company = model.company ?? ""
        self.leaveTime = DateUtils.formatISO8601Date(model.leaveTime ?? "")
    }
}

import Foundation

class URLBuilder {
    private let imageApiDomain: String
    static let defaultURL = URL(string: "www.google.com.tw")!
    
    
    init(imageApiDomain: String = "") {
        self.imageApiDomain = imageApiDomain
    }

    func buildURL(id: String, filepath: String) -> URL? {
        
        let info = UserDefaultsHelper.userBuilding
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        let featurePath = filepath.firstPathComponent()?.withLowercasedFirstLetter() ?? ""
        
        let url = imageApiDomain + "/user/community/\(communityID)/\(featurePath)/\(id)/file?fn=\(filepath)&token=\(token)&b=\(info.building)&d=\(info.doorPlate)&f=\(info.floor)"

        return URL(string: url)
    }
    
    func build1URL(filepath: String) -> URL? {
        
        let imageApiDomain = "https://go.lelelink.com"
        
        let info = UserDefaultsHelper.userBuilding
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        
        let url = imageApiDomain + "/user/community/\(communityID)/file?f=\(filepath)&token=\(token)&b=\(info.building)&d=\(info.doorPlate)&f=\(info.floor)"

        return URL(string: url)
    }
    
    func buildGoURL(filepath: String) -> URL? {
        
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        let imageApiDomain = "https://go.lelelink.com"
        
        let url = imageApiDomain + "/user/community/\(communityID)/file?f=\(filepath)&token=\(token)"

        return URL(string: url)
    }
    
}




//RowData(title: "時間", value: viewModel.visitTime),
//RowData(title: "姓名", value: viewModel.name ?? "未知"),
//RowData(title: "人數", value: "\(viewModel.peopleCount)"),
//RowData(title: "事由", value: viewModel.reason),
//RowData(title: "廠商", value: viewModel.company ?? "無"),
//RowData(title: "離場", value: viewModel.leaveTime!)
