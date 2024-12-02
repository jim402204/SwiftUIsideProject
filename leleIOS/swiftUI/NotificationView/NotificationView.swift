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
                // 頂部分段控制器
                HStack(spacing: 0) {
                    ForEach(viewModel.tabs, id: \.self) { tab in
                        Button(action: {
                            viewModel.tabChanged(to: tab)
                        }) {
                            VStack(spacing: 8) {
                                Text("\(tab)")
                                    .foregroundColor(viewModel.selectedTab == tab ? .teal : .gray)
//                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(viewModel.selectedTab == tab ? .teal : .clear)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .background(Color.white)
                
                // 通知列表
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.notifications, id: \.id) { notification in
                            NotificationItemView(notification: notification)
                        }
                    }
                }
            }
            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .onAppear {
            
            viewModel.loginAPI {
                viewModel.loadNotifications()
            }
        }
    }
}

struct NotificationItemView: View {
    let notification: NotificationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(notification.title)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Text(notification.createAt)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Text(notification.body)
                .font(.system(size: 15))
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        
        Divider()
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
