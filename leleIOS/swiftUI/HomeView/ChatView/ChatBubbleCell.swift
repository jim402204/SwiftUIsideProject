//
//  ChatBubbleCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/27.
//

import SwiftUI

struct ChatBubble: View {
    var message: String
    var isMyMsg: Bool
    
    let spacer: CGFloat = 16
    
    var body: some View {
        HStack {
            if isMyMsg {
                Spacer()
                Text(message)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Spacer()
                    .frame(width: spacer)
            } else {
                Spacer()
                    .frame(width: spacer)
                Text(message)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
//                    .background(Color.gray.opacity(0.2))
                    .background(Color(.systemGray5))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                Spacer()
            }
        }
        .appFont(.subheadline)
        .padding(isMyMsg ? .leading : .trailing, 60)
        .padding(.vertical, 5)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ChatBubble(message: "大型垃圾的處理方式如下:\n1. 請事先連絡服務中心，由清潔隊專人處理。\n2. 如有衍生處理費用，概由住戶負擔。\n3. 請勿直接丟棄大型垃圾，以免造成環境髒亂。", isMyMsg: true)
}
