//
//  SegmentedTabView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

// 泛型版本的分段控制器
struct SegmentedTabView<T: Hashable, Content: View>: View {
    let tabs: [T]
    let selectedTab: T
    let onTabChanged: (T) -> Void
    let content: (T) -> Content
    
    init(
        tabs: [T],
        selectedTab: T,
        onTabChanged: @escaping (T) -> Void,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.tabs = tabs
        self.selectedTab = selectedTab
        self.onTabChanged = onTabChanged
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    onTabChanged(tab)
                }) {
                    VStack(spacing: 8) {
                        content(tab)
                            .foregroundColor(selectedTab == tab ? .teal : .gray)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == tab ? .teal : .clear)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}
