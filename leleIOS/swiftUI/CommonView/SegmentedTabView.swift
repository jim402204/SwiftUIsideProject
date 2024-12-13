//
//  SegmentedTabView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI
protocol TabModel: Hashable {
    var title: String { get }
}

extension TabModel {
    var title: String {
        return "\(self)"
    }
}

// 泛型版本的分段控制器
struct SegmentedTabView<T: Hashable>: View {
    let tabs: [T]
    let selectedTab: T
    let onTabChanged: (T) -> Void
//    let content: (T) -> Content
    
    init(
        tabs: [T],
        selectedTab: T,
        onTabChanged: @escaping (T) -> Void
//        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.tabs = tabs
        self.selectedTab = selectedTab
        self.onTabChanged = onTabChanged
//        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    onTabChanged(tab)
                }) {
                    VStack(spacing: 0) {
                        Text("\(tab)")
                            .frame(height: 34)
                            .appFont(.title3)
                            .foregroundColor(selectedTab == tab ? .teal : .gray)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == tab ? .teal : .clear)
                            .padding(.horizontal,10)
                    }
                    .padding(.vertical,3)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color.white)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SegmentedTabView(
        tabs: ["Tab1", "Tab2", "Tab3"],
        selectedTab: "Tab2",
        onTabChanged: { _ in }
    )
}
