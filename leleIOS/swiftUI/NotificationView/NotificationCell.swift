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
                    .appFont(.body, weight: .medium)
                Spacer()
                Text(DateUtils.formatISO8601Date(model.createAt))
                    .appFont(.subheadline,color: .secondary)
            }
            
            Text(model.body)
                .appFont(.size(16))
                .lineLimit(2)
        }
        .paddingCard(cornerRadius: 10,vertical: 6)
        .paddingCell(horizontal: 6, vertical: 3)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
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





