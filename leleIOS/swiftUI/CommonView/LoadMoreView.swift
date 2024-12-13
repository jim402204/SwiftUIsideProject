//
//  LoadMoreView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/13.
//

import SwiftUI

struct LoadMoreView: View {
    let hasMoreData: Bool
    var onLoadMore: () -> Void = {}
    
    var body: some View {
        Group {
            if hasMoreData {
                ProgressView()
                    .padding()
                    .onAppear {
                        Task {
                            try? await delay(seconds: 0.1)
                            onLoadMore()
                        }
                    }
            } else {
                Text("已加載全部內容")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

// 延迟函数
func delay(seconds: Double) async throws {
    try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}

#Preview(traits: .sizeThatFitsLayout) {
    LoadMoreView(hasMoreData: true, onLoadMore: {})
}
