//
//  PostalServiceCellViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/9.
//

import Foundation

class PostalServiceCellViewModel {
    let id: String
    private let type: FeatureApi.PackageList.Status
    
    let packageID: String
    let initTime: String
    let barCode: String
    var tagLabel: String = ""
    var sender: String?
    var receiver: String
    let packageContent: String?
    /// 冷凍
    let isFreezing: Bool
    /// 冷藏
    let isRefrigeration: Bool
    /// 物流
    var shippingProvider: String? = nil
    let mark: String?
    var checkTime: String? = nil
    /// 物業 放置包裹的地點
    var place: String?
    
    init(model: PackageModel, type: FeatureApi.PackageList.Status) {
        self.id = model.id
        self.type = type
        
        self.packageID = "\(model.packageID)"
        self.initTime = DateUtils.formatISO8601Date(model.initTime)
        self.barCode = model.barCode
        
        let emptyText = "-" //UserDefaultsHelper.userBuilding.buildingText
        let senderDefault = (type == .寄放) ? "其他" : nil
        let receiverDefault = (type == .寄放) ? "其他" : emptyText
        // sender
        let senderText = model.deposit?.senderOtherName ?? model.deposit?.senderDetail?.name ?? model.deposit?.senderProvider ?? senderDefault
        // package
        let depositPackage = model.deposit?.typeCustomName ?? "現金：\(model.deposit?.cashCount ?? 0)元"
        // receiver
        var receiverText: String = receiverDefault
        if type != .寄放 {
            receiverText = model.recipientDetail?.name ?? model.recipientCustomName ?? receiverDefault
        } else {
            receiverText = model.deposit?.receiverDetail?.name ?? model.deposit?.receiverOtherName ?? model.deposit?.receiverProvider ?? receiverDefault
        }
        
        switch type {
        case .未領取: self.tagLabel = "待領取"
        case .已領取: self.tagLabel = "已領取"
        case .退貨:
            if model.status == 4 {
                self.tagLabel = "待退貨"
            } else if model.status == 5 {
                self.tagLabel = "已退貨"
            }
        case .寄放:
            if model.status == 6 {
                self.tagLabel = "待領取"
            } else if model.status == 7 {
                self.tagLabel = "已領取"
            }
        }
        
        self.sender = senderText
        self.receiver = receiverText
        self.packageContent = type != .寄放 ? model.type?.desc : depositPackage
        self.isFreezing = model.isFreezing ?? false
        self.isRefrigeration = model.isRefrigeration ?? false
        
        if  type == .未領取 || type == .已領取 || type == .退貨 {
            self.shippingProvider = model.shippingProvider?.desc ?? ""
        } else {
            self.shippingProvider = model.shippingProvider?.desc
        }
        
        self.mark = model.ps
        
        if let checkTime = model.checkTime {
            self.checkTime = DateUtils.formatISO8601Date(checkTime)
        }
        
        self.place = model.place
        
    }
}
