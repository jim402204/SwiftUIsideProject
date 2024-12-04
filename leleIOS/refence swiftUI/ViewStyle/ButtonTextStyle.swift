//
//  ButtonTextStyle.swift
//  CoursePass
//
//  Created by 江俊瑩 on 2022/4/12.
//

import SwiftUI

struct ConfirmButtonStyle: ViewModifier {
    
    var textSize: CGFloat
    var bgColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: textSize))
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
            .foregroundColor(Color.white)
            .background(bgColor)
            .cornerRadius(24)
    }
}

extension View {
    func confirmStyle(_ size: CGFloat = 16, bgColor: Color = Color.app(.primary500)) -> some View {
        self.modifier(ConfirmButtonStyle(textSize: size, bgColor: bgColor))
    }
}

struct ButtonTextStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        Button {
            
        } label: {
            Text("Comfirom")
    //            .modifier(confiemStyle())
                .confirmStyle(bgColor: .red)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
//        .previewLayout(.fixed(width: 300, height: 300))
    }
}

//contentShape 是可以幫Stack增加點擊範圍 後面加 onTapGesture

//VStack {
//    Image(systemName: "person.circle")
////                    .resizable()
//        .frame(width: 100, height: 70)
//        .background(Color.red)
//
//    Button(action: viewModel.conformAcrion) {
//        Text("下一頁").confirmStyle()
//    }
//}
//.contentShape(Rectangle())
//.onTapGesture {
//    print("zdfsfsf")
//}
