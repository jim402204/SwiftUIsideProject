//
//  Navigation+.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/6.
//

import SwiftUI

//MARK: - 自訂NavigationBar樣式 navigationBarStyle

struct CustomNavigationBarStyle: ViewModifier {
    @Environment(\.dismiss) private var dismiss
   
    var title: String
    var displayMode: NavigationBarItem.TitleDisplayMode
    var backgroundColor: Color
    var isRootPage: Bool
    var hasTitleIcon: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.visible, for: .navigationBar) // 確保背景顯示
            .toolbarBackground(backgroundColor, for: .navigationBar) // 設置背景顏色
            .navigationBarTitleDisplayMode(displayMode)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if hasTitleIcon {
//                        NavigationLink(destination: QRCodeScanView()) {
                            HStack {
//                                Image("Icon-App-1024x1024")
                                Image("barIcon")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .cornerRadius(10)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 1) // 邊線顏色與寬度
                                        )
                                
                                initTitleView()
                            }
//                        }
                    } else {
                        initTitleView()
                    }
                }
            }// 隱藏並自製backBar
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 只有當前不是第一層時，顯示返回按鈕
                if !isRootPage {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
    }
    
    
    func initTitleView() -> some View {
        Text(title)
            .appFont(.size(24))
            .foregroundStyle(.white) // 設置標題樣式
    }
}

import UIKit
//MARK: - 自訂NavigationBar 可以右滑返回
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension View {
    func navigationBarStyle(
        title: String,
        backgroundColor: Color = .teal,
        displayMode: NavigationBarItem.TitleDisplayMode = .inline,
        isRootPage: Bool = false,
        hasTitleIcon: Bool = true
    ) -> some View {
        self.modifier(
            CustomNavigationBarStyle(
                title: title,
                displayMode: displayMode,
                backgroundColor: backgroundColor,
                isRootPage: isRootPage,
                hasTitleIcon: hasTitleIcon
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

//MARK: - 隱藏BackBar 範例

struct CustomNavigationBackBarView: View {
    @Environment(\.dismiss) private var dismiss
    var arrowColor: Color = .white
    
    var body: some View {
        VStack {
            Text("子頁面內容")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(arrowColor)
                    }
                }
            }
        }
    }
}
