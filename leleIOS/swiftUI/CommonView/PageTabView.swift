//
//  BaseTabView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/2.
//

import SwiftUI

/// 封裝的 TabView 有page功能
struct PageTabView<Item, CellView: View, T: Hashable>: View {
    var tabs: [T]
    @Binding var selectedTab: T
    var allList: [T: [Item]]
    var onChange: (T) -> Void = { _ in }
    var cellBuilder: (Item) -> CellView
    
    var isLoadMore: Bool = false
    var loadMoreAPI: () -> Void = { }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabs, id: \.self) { tab in
                ScrollView {
                    if (allList[tab]?.isEmpty ?? true) {
                        emptyView()
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(
                                Array((allList[tab] ?? []).enumerated()),
                                id: \.offset
                            ) { index, item in
                                cellBuilder(item)
                                    .id(index)
                            }
                        }
                    }
                }
                .tag(tab) // 設定對應的標籤，確保切換正確
            }
            LoadMoreView(hasMoreData: isLoadMore) {
                loadMoreAPI()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // 隱藏內建指示器
        .onChange(of: selectedTab) {
            onChange($1)
        }//本身TabView 會更改 $selectedTab 有綁定就不需要例外寫onChange
    }
}
