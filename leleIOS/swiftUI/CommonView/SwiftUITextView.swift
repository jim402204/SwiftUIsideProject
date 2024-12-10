//
//  CustomTextView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct SwiftUITextView: UIViewRepresentable {
    var text: String
    var fontSize: CGFloat = 17
    var lineBreakMode: NSLineBreakMode = .byWordWrapping // 換行模式

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = lineBreakMode
        textView.font = UIFont.systemFont(ofSize: fontSize)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

