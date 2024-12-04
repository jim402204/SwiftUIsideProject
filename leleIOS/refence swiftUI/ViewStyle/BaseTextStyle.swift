//
//  BaseTextStyle.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/12.
//

import SwiftUI

struct RegisterTitleTextStyle: ViewModifier {
    
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.system(size: textSize).bold())
            .foregroundColor(Color.app(.primary500))
           
    }
}

extension View {
    func titleText(_ size: CGFloat = 20) -> some View {
        self.modifier(RegisterTitleTextStyle(textSize: size))
    }
}

struct BaseTextStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("Text")
                .titleText()
                .previewDisplayName("註冊流程中的title")
                .previewLayout(.sizeThatFits)
            .padding(.all, 5)
//            .previewLayout(.fixed(width: 300, height: 300))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
            //終端機 xcrun simctl list devicetypes 列出所有裝置字串
            
            Text("Text")
                .titleText()
                .previewDisplayName("顯示多個狀態")
                .previewLayout(.sizeThatFits)
                .padding(.all, 5)
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark) //顯示dark Model
        }

    }
}







