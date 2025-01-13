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

struct PostalServiceCell: View {
    let viewModel: PostalServiceCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: 0) {
                Text("#\(viewModel.packageID)")
                    .appFont(.largeTitle, color: .teal)
                    .bold()
                Spacer()
                
                Text(viewModel.initTime)
                    .appFont(.subheadline, color: .secondary)
                Spacer()
                
                Text("\(viewModel.tagLabel)")
                    .tagStyle(background: .teal.opacity(2))
            }
            
            let spacerWith: CGFloat = 100
            VStack(alignment: .leading, spacing: 8) {
                
                if let sender = viewModel.sender {
                    HStack() {
                        HStack {
                            Text("寄件人:")
                            Spacer()
                        }.frame(width: spacerWith)
                        Text(sender)
                    }
                }
                
                HStack() {
                    HStack {
                        Text("收件人:")
                        Spacer()
                    }.frame(width: spacerWith)
                    Text(viewModel.receiver)
                }
                
                if let package = viewModel.packageContent {
                    HStack() {
                        HStack {
                            Text("包裹内容:")
                            Spacer()
                        }.frame(width: spacerWith)
                        
                        Text(package)
                        
                        if viewModel.isFreezing {
                            HStack(spacing: 2) {
                                    Image(systemName: "snowflake")
                                    Text("冷凍")
                                }
                            .tagStyle(background: .teal.opacity(0.8))
                            .appFont(.footnote)
                        }
                        
                        if viewModel.isRefrigeration {
                            HStack(spacing: 2) {
                                    Image(systemName: "snowflake")
                                    Text("冷藏")
                                }
                            .tagStyle(background: .teal.opacity(0.8))
                            .appFont(.footnote)
                        }
                    }
                }
                
//                if let shippingProvider = viewModel.shippingProvider {
//                    HStack() {
//                        HStack {
//                            Text("物流:")
//                            Spacer()
//                        }.frame(width: spacerWith)
//                        Text(shippingProvider)
//                    }
//                }
                
//                HStack() {
//                    HStack {
//                        Text("條碼:")
//                        Spacer()
//                    }.frame(width: spacerWith)
//                    Text(viewModel.barCode)
//                }
                
                if let mark = viewModel.mark {
                    HStack() {
                        HStack {
                            Text("備註:")
                            Spacer()
                        }.frame(width: spacerWith)
                        Text(mark)
                            .appFont(.size(18))
                            .foregroundColor(.teal)
                    }
                }
                
                if let checkTime = viewModel.checkTime {
                    HStack() {
                        HStack {
                            Text("領取時間:")
                            Spacer()
                        }.frame(width: spacerWith)
                        Text(checkTime)
                    }
                }
                
            }
            .appFont(.body)
        }
        .paddingCard(horizontal: 16)
        .paddingCell(vertical: 6)
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    let packageModel = PackageModel(
//        id: "1",
//        packageID: 23,
//        barCode: "123453123123",
//        type: PackageModel.ShippingFrom(name: "物流公司", desc: "包裹内容"),
//        status: 1,
//        initTime: "2023-03-01T08:53:30.358Z",
//        checkTime: "2023-03-01T08:54:05.358Z",
//        sender: PackageModel.RecipientDetail(id: "1", name: "王大明1", privateNotify: nil) ,
//        receiver: "寄件人姓名",
//        shippingProvider: PackageModel.ShippingFrom(name: "物流公司", desc: "物流公司描述"),
//        ps: "備註",
//        recipientDetail: nil,
//        isFreezing: nil,
//        shippingFrom: nil,
//        isRefrigeration: nil,
//        recipientCustomName: "收件人姓名"
//    )
//
//    let viewModel = PostalServiceCellViewModel(model: packageModel, type: .未領取)
//    
//    PostalServiceCell(viewModel: viewModel)
//}
