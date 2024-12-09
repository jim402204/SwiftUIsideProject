//
//  AppText.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/9.
//

import Foundation
import SwiftUI

// 系統文字樣式
enum AppFontSize {
    /// 34
    case largeTitle
    /// 28
    case title
    /// 22
    case title2
    /// 20
    case title3
    /// 17
    case body
    /// 15 用在日期
    case subheadline
    /// 13
    case footnote
    /// 12
    case caption
    /// 11
    case caption2

    // 自定義大小
    case size(CGFloat)

    /// 返回對應的系統 `Font`
    var font: Font {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title
        case .title2:
            if #available(iOS 14.0, *) { return .title2 } else { return .title }
        case .title3:
            if #available(iOS 14.0, *) { return .title3 } else { return .title }
        case .body: return .body
        case .subheadline: return .subheadline
        case .footnote: return .footnote
        case .caption: return .caption
        case .caption2:
            if #available(iOS 14.0, *) { return .caption2 } else { return .caption }
        case .size(let size): return .system(size: size)
        }
    }
}


extension View {
    /// 使用混合文字大小的修飾符
    func appFont(_ size: AppFontSize, weight: Font.Weight = .regular) -> some View {
        self.font(size.font.weight(weight))
    }
}

extension View {
    func appFont(_ size: AppFontSize, weight: Font.Weight = .regular, color: Color) -> some View {
        self.font(size.font.weight(weight))
            .foregroundColor(color)
    }
}


//Apple 預設文字樣式
//文字樣式    對應大小 (pt)    描述
//.largeTitle    34    用於主頁面或重要內容的標題。
//.title    28    次要標題，重要內容的區域標題。
//.title2    22    小一級的次要標題。
//.title3    20    更小的次要標題。
//.headline    17 (粗體)    用於突出的文字內容。
//.body    17    用於正文內容，默認大小。
//.callout    16    次要信息，用於輔助內容。
//.subheadline    15    較小的文字，用於次要內容。
//.footnote    13    輔助文字，例如註釋或標記。
//.caption    12    小字體，用於次要說明或標題。
//.caption2    11    更小的文字，用於非常次要的內容。
