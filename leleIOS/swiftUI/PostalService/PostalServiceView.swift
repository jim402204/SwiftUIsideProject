//
//  PostalServiceView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct PostalServiceView: View {
    @StateObject private var viewModel = PostalServicViewModel()
    var isRootPage: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 分段控制器
            SegmentedTabView(
                tabs: viewModel.tabs,
                selectedTab: viewModel.selectedTab,
                onTabChanged: viewModel.tabChanged
            )
            
            // 對講列表
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.0) {
                        index,
                        item in
                        PostalServiceCell(viewModel: item)
                    }
                }
            }
        }
        .navigationBarStyle(title: "包裹寄物",isRootPage: isRootPage)
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        PostalServiceView()
    }
}
