//
//  NotificationCell.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

struct NotificationCell: View {
//    var model: NotificationModel! = nil
    let model: NotificationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(model.title)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Text(model.createAt)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Text(model.body)
                .font(.system(size: 15))
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        
        Divider()
    }
}

#Preview {
    NotificationCell(model: NotificationCell.preview())
}

extension NotificationCell {
    static func preview() -> NotificationModel {
        NotificationModel(
            id: "1",
            title: "社區通知",
            body: "您的包裹已送達，請至大廳領取。",
            createAt: "2024-12-03 12:00",
            notification: nil,
            type: 1,
            lastNotify: "2024-12-03 11:00",
            recipient: [
                NotificationModel.Recipient(user: "John Doe", readAt: nil),
                NotificationModel.Recipient(user: "Jane Smith", readAt: "2024-12-03 13:00")
            ],
            voice: "default",
            package: "包裹123"
        )
    }
}





