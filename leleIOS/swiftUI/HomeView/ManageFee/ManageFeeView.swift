//
//  ManageFeeView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import SwiftUI

struct ManageFeeView: View {
    @State var viewModel = ManageFeeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SegmentedTabView(
                tabs: viewModel.tabs,
                selectedTab: $viewModel.selectedTab,
                onTabChanged: viewModel.tabChanged
            )
            
            // 對講列表
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        Text(item.title)
                    }
                }
            }
        }
        .navigationBarStyle(title: "管理費")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        ManageFeeView()
    }
}
