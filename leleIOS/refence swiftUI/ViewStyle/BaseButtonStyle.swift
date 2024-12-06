//
//  BaseButtonStyle.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/3.
//

import SwiftUI

struct BaseButtonStyle: ViewModifier {
    var height: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            .background(RoundedRectangle(cornerRadius: (height/2)).fill(Color.teal))
            .foregroundColor(.white)
            .applyShadow()
    }
}

//Button(action: {
//    viewModel.login()
//}) {
//    ZStack {
//        RoundedRectangle(cornerRadius: 22)
//            .fill(Color.teal)
//            .frame(maxWidth: .infinity, maxHeight: 50)
//        Text("登入")
//            .foregroundColor(.white)
//    }
//}
//.padding(.horizontal)
//.shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
