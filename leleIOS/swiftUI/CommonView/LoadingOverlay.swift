//
//  LoadingOverlay.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/27.
//

import SwiftUI
import ActivityIndicatorView
import Observation

// 全局的 LoadingManager
@Observable
class LoadingManager {
    static let shared = LoadingManager()
    
    var isLoading: Bool = false
}

// 自定义 ViewModifier
struct LoadingOverlayModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isLoading {
                        ZStack {
                            Color.black.opacity(0.3) // 半透明遮罩
                                .edgesIgnoringSafeArea(.all)

                            ActivityIndicatorView(isVisible: $isLoading, type: .default(count: 8))
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                    }
                }
            )
    }
}

// 扩展 View，便于调用
extension View {
    func loadingOverlay(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}
