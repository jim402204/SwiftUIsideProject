//
//  View+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/6.
//

import SwiftUI

extension View {
    func applyShadow(radius: CGFloat = 3) -> some View {
        self.shadow(color: .gray.opacity(0.5), radius: radius, x: 0, y: 1)
    }
    
    // 擠成卡片 在paddingCell 成Cell
    func paddingCard(
        bgColor: Color = .white,
        cornerRadius: CGFloat = 20,
        horizontal: CGFloat = 16,
        vertical: CGFloat = 12
    ) -> some View {
        self
            .padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
            .background(bgColor)
            .cornerRadius(cornerRadius)
            .applyShadow()
    }
    
    func paddingCell(horizontal: CGFloat = 16, vertical: CGFloat = 3) -> some View {
        self
            .padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
    }
}

// MMARK: - EmptyView

extension View {
    
    /// Text 已加載全部內容
    @ViewBuilder
    func emptyView() -> some View {
        Text("已加載全部內容")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
    }
    
}
