//
//  IntercomView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct IntercomView: View {
    @StateObject private var viewModel = IntercomViewModel()
    
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
                    ForEach(viewModel.intercomList, id: \.id) { item in
                        IntercomCell(viewModel: item)
                    }
                }
            }
        }
        .navigationBarStyle(title: "智慧對講")
        .navigationBarItems(trailing:
                                Button(action: {
            // 設置按鈕動作
        }) {
            Image(systemName: "gearshapeX")
                .foregroundColor(.primary)
        }
        )
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        IntercomView()
    }
}
