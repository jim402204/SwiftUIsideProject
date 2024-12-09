//
//  Navigation+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/6.
//

import SwiftUI

// 定義枚舉，作為導航堆疊中的標識符
enum NavigationPage: Hashable {
    case home
    case detail(id: Int, title: String)
    case settings
}

//extension NavigationPath {
//    mutating func popToTarget(_ target: NavigationPage) {
//        // 將堆疊轉為數組
//        var updatedStack = self.map { $0 as? NavigationPage }.compactMap { $0 }
//
//        let jim = self
//
//        // 遍歷堆疊並移除不匹配的頁面
//        for currentPage in updatedStack.reversed() {
//            if let page = currentPage as? NavigationPage, page == target {
//                break // 找到目標頁面，停止移除
//            }
//            updatedStack.removeLast()
//        }
//
//        // 使用處理後的數組重新構建 NavigationPath
//        self = NavigationPath(updatedStack)
//    }
//    
//    /// 返回堆疊中所有的 `NavigationPage` 元素
//    func pages<T>() -> [T] {
//        self.compactMap { $0 as? T }
//    }
//}

import SwiftUI

struct CustomNavigationBarStyle: ViewModifier {
    
    @Environment(\.presentationMode) var presentationMode
    var title: String
    var displayMode: NavigationBarItem.TitleDisplayMode
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.visible, for: .navigationBar) // 確保背景顯示
            .toolbarBackground(backgroundColor, for: .navigationBar) // 設置背景顏色
            .navigationBarTitleDisplayMode(displayMode)
//            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .appFont(.size(24))
                        .foregroundStyle(.white) // 設置標題樣式
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss() // 返回上一頁
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left") // 自製箭頭圖標
////                            Text("返回") // 自製文字
//                        }
//                        .foregroundColor(.white) // 設置箭頭和文字顏色
//                    }
//                }
//            }
    }
}

extension View {
    func navigationBarStyle(
        title: String,
        backgroundColor: Color = .teal,
        displayMode: NavigationBarItem.TitleDisplayMode = .inline
    ) -> some View {
        self.modifier(
            CustomNavigationBarStyle(
                title: title,
                displayMode: displayMode,
                backgroundColor: backgroundColor
            )
        )
    }
}

extension View {
    func ifLet<Value, Transform: View>(
        _ value: Value?,
        transform: (Self, Value) -> Transform
    ) -> some View {
        if let value = value {
            return AnyView(transform(self, value))
        } else {
            return AnyView(self)
        }
    }
}

//NavigationStack {
//    Text("Content")
//        .customNavigationBarStyle(title: "智慧對講", backgroundColor: .teal) // 使用自定義樣式
//}
