//
//  PostalServiceCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct IdentifiableModel<T>: Identifiable {
    let id = UUID() // 每次創建自動生成唯一標識符
    let model: T    // 包裝的原始模型
}

struct FakeCell: View {
    let wrapper: IdentifiableModel<PackageModel>
    
    var body: some View {
        HStack {
            Text("Hello, World!")
            
            Text("asdas\(wrapper.model.packageID)")
        }
    }
}

struct PostalServiceCell: View {
    let model: PackageModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 20) {
                Text("#\(model.packageID)")
                    .appFont(.largeTitle, color: .teal)
                    .bold()

                Text(DateUtils.formatISO8601Date(model.initTime))
                    .appFont(.subheadline, color: .secondary)
                
                Text("已領取")
                    .tagStyle(background: .green)
            }
            
            Group {
                Text("收件人: \(model.recipientDetail?.name ?? UserDefaultsHelper.userBuilding.buildingText)")
                
                HStack() {
                    Text("包裹内容: \(model.type.desc)")
                    
                    if model.isFreezing == true {
                        Text("❄️ 冷冻")
                            .foregroundColor(.blue)
                    }
                }
                
                Text("物流: \(model.shippingProvider?.desc ?? "")")
                
                Text("條碼: \(model.barCode)")
                
                if let mark = model.ps {
                    Text("備註: \(mark)")
                        .foregroundColor(.teal)
                }
                
                if let checkTime = model.checkTime {
                    Text("領取時間: \(DateUtils.formatISO8601Date(checkTime))")
                }
            }
            .appFont(.body)
            
        }
        .paddingCard()
        .paddingCell(vertical: 6)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PostalServiceCell(model: PackageModel(
        id: "1",
        packageID: 23,
        barCode: "123453123123",
        type: PackageModel.ShippingFrom(name: "物流公司", desc: "描述"),
        status: 1,
        initTime: "2023-02-14 15:42",
        checkTime: "2023-02-14 15:45",
        shippingProvider: nil,
        ps: "包裹",
        recipientDetail: PackageModel.RecipientDetail(id: "1", name: "王大明1", privateNotify: nil),
        isFreezing: true,
        shippingFrom: nil,
        isRefrigeration: nil,
        recipientCustomName: nil
    ))
}
