//
//  TextFieldStyle.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/28.
//

import SwiftUI

#if DEBUG
struct TextFieldStyle_Previews: PreviewProvider {
    @State static var text = ""

    static var previews: some View {
        TextField("placehold", text: $text)
            .textFieldStyle(.custom())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif

extension TextFieldStyle where Self == JimTextFieldStyle {
//    static var custom: JimTextFieldStyle { JimTextFieldStyle() }
    
    static func custom(edgeInsets: EdgeInsets = EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10),
                       height: CGFloat = 40,
                       cornerRadius: CGFloat = 10,
                       background: Color = .white,
                       borderColor: Color = .gray.opacity(0.5)
    ) -> JimTextFieldStyle {

        return JimTextFieldStyle(edgeInsets: edgeInsets, height: height, cornerRadius: cornerRadius, background: background, borderColor: borderColor)
    }

}

struct JimTextFieldStyle: TextFieldStyle {
    
    let edgeInsets: EdgeInsets
    let height: CGFloat
    let cornerRadius: CGFloat
    let background: Color
    let borderColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(edgeInsets)
            .frame(height: height)
            .background(
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(background)
//                        .fill(background)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 0.5)
                }
            )

//            .background(
//                background
//                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(borderColor, lineWidth: 0.5)
//            )
        
//                    .textFieldStyle(.roundedBorder)
    }
}
