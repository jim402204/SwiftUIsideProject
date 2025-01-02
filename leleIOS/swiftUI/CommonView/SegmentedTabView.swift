//
//  SegmentedTabView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

// 泛型版本的分段控制器
struct SegmentedTabView<T: Hashable>: View {
    let tabs: [T]
    let selectedTab: T
    let onTabChanged: (T) -> Void
    let titleMapping: [T: String]
    
    init(
        tabs: [T],
        selectedTab: T,
        titleMapping: [T: String] = [:],
        onTabChanged: @escaping (T) -> Void
    ) {
        self.tabs = tabs
        self.selectedTab = selectedTab
        self.onTabChanged = onTabChanged
        self.titleMapping = titleMapping
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    onTabChanged(tab)
                }) {
                    VStack(spacing: 0) {
                        Text(titleMapping[tab] ?? "\(tab)")
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
