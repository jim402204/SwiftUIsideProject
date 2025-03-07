//
//  GuestCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/11.
//

import SwiftUI
import Kingfisher

struct GuestCell: View {
    let viewModel: GuestCellViewModel
    var rows: [RowData] {[
            RowData(title: "時間", value: viewModel.visitTime),
            RowData(title: "姓名", value: viewModel.name),
            RowData(title: "人數", value: viewModel.peopleCount),
            RowData(title: "事由", value: viewModel.reason),
            RowData(title: "廠商", value: viewModel.company),
            RowData(title: "離場", value: viewModel.leaveTime)
    ]}
    
    @State private var imageHeight: CGFloat = 50 // 預設高度
    // 16 * 2 = 32
    let cellWidth = (UIScreen.main.bounds.width - 32)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            
            KFImage(viewModel.imageUrl)
                .cacheOriginalImage()
                .cancelOnDisappear(true)
                .placeholder {
                    ProgressView()
                }
                .onSuccess { object in
                    let image = object.image
                    // 根據實際圖片計算最適高度
                    imageHeight = image.size.height * (cellWidth / image.size.width)
                }
                .resizable()
//                .aspectRatio(contentMode: .fit)
                .frame(height: imageHeight)
//                .background(Color(.systemGray4))
            
            VStack(spacing: 4) {
                ForEach(rows) { row in
                    HStack {
                        Spacer().frame(width: 40)
                        Text(row.title)
                        Spacer().frame(width: 30)
                        Text(row.value)
                        Spacer()
                    }
                }
            }
            .padding(.vertical,10)
        }
        .background(Color(UIColor(hex: "C8E4E9")))
        .cornerRadius(20)
        .applyShadow()
        .paddingCell(vertical: 8)
    }
    
    // 数据模型
    struct RowData: Identifiable {
        let id = UUID()
        let title: String
        let value: String
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GuestCell(
        viewModel: GuestCellViewModel(model:GuestListModel(
            id: "123",
            peopleCount: 3,
            reason: "Meeting",
            company: "XYZ Corp",
            name: "John Doe",
            webCamFileName: nil,
            leaveTime: "2024-12-11T10:30:00Z",
            status: 1,
            visitTime: "2024-12-11T10:30:00Z"
        )
        )
    )
}



