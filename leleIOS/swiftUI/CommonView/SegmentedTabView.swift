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
    @Binding var selectedTab: T
    var onTabChanged: (T) -> Void = { _ in }
    var titleMapping: [T: String] = [:]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    onTabChanged(tab)
                    selectedTab = tab
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
    @Previewable @State var selectedTab = "Tab2"
    
    SegmentedTabView(
        tabs: ["Tab1", "Tab2", "Tab3"],
        selectedTab: $selectedTab,
        onTabChanged: { _ in }, titleMapping: [:]
    )
}
