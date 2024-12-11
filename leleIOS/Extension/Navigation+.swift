//
//  Navigation+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/6.
//

import SwiftUI

//MARK: - 自訂NavigationBar樣式 navigationBarStyle

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


//MARK: - NavigationPath pop 到指定頁面


extension NavigationPath {
    /// pop回指定view
    mutating func popToTarget(_ target: AnyHashable) {
        var allElements = self.allElements()
        guard allElements.contains(target) else {
            print("Target \(target) not found in NavigationPath")
            return
        }

        while let last = allElements.last, last != target {
            allElements.removeLast()
            self.removeLast()
        }
    }
    /// 拿到所有元素
    func allElements() -> [AnyHashable] {
        Mirror(reflecting: self)
            .children
            .compactMap { $0.value as? [AnyHashable] }
            .flatMap { $0 }
    }
    /// 取得指定 NavigationPath
    subscript(index: Int) -> AnyHashable? {
        let elements = self.allElements()
        guard index >= 0 && index < elements.count else { return nil }
        return elements[index]
    }
}
   


