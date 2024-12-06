//
//  IntercomCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct IntercomCell: View {
    let viewModel: IntercomCellViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // 左側圖標
            Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 30, height: 20)
                .foregroundColor(.teal)
            
            // 中間文字
            Text(viewModel.name)
                .font(.system(size: 16))
            
            Spacer()
            
            // 右側通話按鈕
            Image(systemName: viewModel.isEnable ? "phone.fill" : "phone.down.fill")
                .foregroundColor(viewModel.isEnable ? .green : .red)
        }
        .paddingCard(cornerRadius: 10)
        .paddingCell()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    IntercomCell(
        viewModel: IntercomCellViewModel(
            IntercomListModel(
                id: "",
                name: "管理中心",
                canDial: true,
                device: nil,
                building: nil,
                doorPlate: nil,
                floor: nil
            ),
            status: .社區
        )
    )
}
