//
//  GuestViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/11.
//
import RxSwift
import SwiftUI

class GuestViewModel: ObservableObject {
    var disposeBag = DisposeBag()
    
    @Published var list: [GuestCellViewModel] = []
    
    init() {
        callAPI()
    }
    
    func callAPI() {
        
        
        apiService.request(NotifyApi.GuestList())
            .subscribe(onSuccess: { [weak self] model in
                    
                guard let self = self else { return }
                
                let models = model.map { GuestCellViewModel(model: $0) }
                self.list = models

            }).disposed(by: disposeBag)
    }
    
}

class GuestCellViewModel {
    
    let imageUrl: String
    let visitTime: String
    let name: String
    let peopleCount: String
    let reason: String
    let company: String
    let leaveTime: String
    
    init (model: GuestListModel) {
        
        let info = UserDefaultsHelper.userBuilding
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        let filepath = model.webCamFileName ?? ""
        
        let url = imageApiDomain + "/user/community/\(communityID)/guest/\(model.id)/file?fn=\(filepath)&token=\(token)&b=\(info.building)&d=\(info.doorPlate)&f=\(info.floor)"
        
        self.imageUrl = url
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
