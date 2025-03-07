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

//RowData(title: "時間", value: viewModel.visitTime),
//RowData(title: "姓名", value: viewModel.name ?? "未知"),
//RowData(title: "人數", value: "\(viewModel.peopleCount)"),
//RowData(title: "事由", value: viewModel.reason),
//RowData(title: "廠商", value: viewModel.company ?? "無"),
//RowData(title: "離場", value: viewModel.leaveTime!)
