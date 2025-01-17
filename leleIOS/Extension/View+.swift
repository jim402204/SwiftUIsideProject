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

// MMARK: - 限制最大字數

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int, shouldLimit: Bool) -> some View {
        if shouldLimit {
            return AnyView(self.modifier(TextFieldLimitModifer(value: value, length: length)))
        } else {
            return AnyView(self)
        }
    }
}

import Combine

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .onChange(of: $value.wrappedValue) {
                    value = String($1.prefix(length))
                }
        } else {
            content
                .onReceive(Just(value)) {
                    value = String($0.prefix(length))
                }
        }
    }
}

// MMARK: - 關閉鍵盤
extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

let sideLinesGray = Color.gray.opacity(0.3)

// MMARK: - 新增圓角background
extension View {
    func roundedBackground(cornerRadius: CGFloat = 10,
                           strokeColor: Color = sideLinesGray,
                           lineWidth: CGFloat = 1) -> some View {
        self.modifier(RoundedBackgroundModifier(cornerRadius: cornerRadius, strokeColor: strokeColor, lineWidth: lineWidth))
    }
}

struct RoundedBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    let strokeColor: Color
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
}

// MMARK: - TextField取得焦點
/// TextField取得焦點 提供雙向綁定
/// 提供雙向綁定
struct FocusedState: ViewModifier {
    @FocusState private var isFocused: Bool
    // swiftUI 變化 綁定給viewModel
    @Binding var externalFocus: Bool?
    
    init(externalFocus: Binding<Bool?>? = nil) {
        self._externalFocus = externalFocus ?? .constant(nil) // 如果未绑定，使用 `nil`
    }
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) {
                externalFocus = $1 // 绑定到外部
            }
    }
}

extension View {
    func focusedState(
        binding: Binding<Bool?>
    ) -> some View where Self == TextField<Text> {
        self.modifier(FocusedState(externalFocus: binding))
    }
    
    func focusedState() -> some View where Self == TextField<Text> {
        
        self.modifier(FocusedState())
    }
}
