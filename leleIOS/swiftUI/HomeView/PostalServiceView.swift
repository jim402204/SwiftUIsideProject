//
//  PostalServiceView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct PostalServiceView: View {
    @StateObject private var viewModel = PostalServicViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 分段控制器
            SegmentedTabView(
                tabs: viewModel.tabs,
                selectedTab: viewModel.selectedTab,
                onTabChanged: viewModel.tabChanged
            ) { tab in
                Text("\(tab)")
            }
            
            // 對講列表
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.0) { index, item in
                        PostalServiceCell(model: item)
                    }
                }
            }
        }
        .navigationBarStyle(title: "郵務")
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    PostalServiceView()
}
