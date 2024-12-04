//
//  NotificationView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 使用泛型版本的分段控制器
                SegmentedTabView(
                    tabs: viewModel.tabs,
                    selectedTab: viewModel.selectedTab,
                    onTabChanged: viewModel.tabChanged
                ) { tab in
                    Text("\(tab)")
                }
                
                // 通知列表
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.notifications, id: \.id) { notification in
                            NotificationCell(model: notification)
                        }
                    }
                }
            }
            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .onAppear {
            viewModel.callAPI()
        }
    }
}



struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
