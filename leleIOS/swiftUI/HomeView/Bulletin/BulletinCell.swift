//
//  BulletinCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct BulletinCell: View {
    let viewModel: BulletinCellViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                
                Group {
                    if viewModel.isTop {
                        Text("置頂")
                            .tagStyle(background: .orange)
                    }
                    Text(viewModel.type)
                        .tagStyle(background: .green)
                }
                .appFont(.footnote)
                
                Text(viewModel.title)
                    .appFont(.body,color: .black)
                    .lineLimit(1)
                
                Spacer()
                
                Text(viewModel.date)
                    .appFont(.subheadline, color: .secondary)
            }
            .paddingCell(horizontal: 6,vertical: 16)
            
            Divider()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BulletinCell(
        viewModel: BulletinCellViewModel(
            type: "活動",
            title: "大家一起去爬山",
            date: "2024-04-03T06:34:59.278Z",
            content: "爬山囉！\n",
            isTop: true
        )
    )
}

