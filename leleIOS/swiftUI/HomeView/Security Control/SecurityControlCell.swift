//
//  SecurityControlCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//
import SwiftUI

struct SecurityControlCell: View {
    let viewModel: MediaListModel
    
    var body: some View {
        HStack(spacing: 15) {
            // 左側圖標
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 25, height: 20)
                .foregroundColor(.teal)
            
            Text(viewModel.name)
                .appFont(.body)
            
            Spacer()
            Image(systemName: arrowIcon)
                .foregroundColor(.gray)
        }
        .paddingCard(cornerRadius: 10)
        .paddingCell()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SecurityControlCell(
        viewModel: .init(id: "1", name: "門口機", model: .init())
    )
}
