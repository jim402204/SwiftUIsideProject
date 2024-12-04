//
//  BaseButtonContent.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/3.
//

import SwiftUI

struct CustomButtonContent: View {
    var title: String
    var height: CGFloat

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: (height/2))
                .fill(Color.teal)
                .frame(height: height)
            Text(title)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
        }
        .fixedSize(horizontal: true, vertical: false)
        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
    }
}
