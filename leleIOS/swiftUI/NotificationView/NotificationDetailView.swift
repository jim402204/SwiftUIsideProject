//
//  NotificationDetailView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/8.
//

import SwiftUI

struct NotificationDetailView: View {
    let notification: NotificationModel

    var body: some View {
        VStack(spacing: 5) {
            Spacer().frame(height: 10)
            
            HStack {
                Text(notification.title)
                    .appFont(.title2)
                Spacer()
            }
            .padding(.horizontal, 5)
            
            SwiftUITextView(
                text: notification.body,
                fontSize: 20,
                lineBreakMode: .byCharWrapping
            )
        }
        .padding(.horizontal)
        .navigationBarStyle(title: "通知內容")
        .background(Color(UIColor.systemGroupedBackground))
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    NotificationDetailView(
        notification: NotificationModel(
            id: "11",
            title: "title",
            body: "body asf;osjf;s\nsdlsjg;sdj\n\n\n\n\n\n\n\n\n\n\nsdl;fdmsf",
            createAt: "",
            notification: "",
            type: 1,
            lastNotify: "",
            recipient: [],
            voice: "",
            package: nil
        )
    )
}
