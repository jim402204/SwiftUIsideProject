//
//  SwiftUIViewdd.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct BulletinDetailView: View {
    let viewModel: BulletinCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.title)
                .appFont(.title2)
                .bold()
            
            HStack {
                Text(viewModel.date)
                    .appFont(.subheadline, color: .secondary)
                
                Text(viewModel.type)
                    .tagStyle(background: .green)
                    .font(.subheadline)
            }
            
            if let updateDate = viewModel.updateDate {
                HStack(spacing: 6) {
                    Text("最後更新")
                    Text(updateDate)
                        .appFont(.subheadline, color: .secondary)
                }
            }
            
            Divider()
            
            SwiftUITextView(
                text: viewModel.content,
                fontSize: 20,
                lineBreakMode: .byCharWrapping
            )
            
            Spacer()
        }
        .padding()
        .navigationBarStyle(title: "公告內容")
    }
}

#Preview {
    NavigationStack {
        BulletinDetailView(viewModel: BulletinCellViewModel(
            type: "活動",
            title: "大家一起去爬山",
            date: "2024-12-06",
            content: "爬山囉！",
            isTop: false
            )
        )
    }
}
