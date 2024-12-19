//
//  ChatView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/19.
//

import SwiftUI

struct ChatView: View {
    @State private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        Text(item.msg)
                    }
                }
            }
            
            HStack {
                TextField("留言", text: $viewModel.message)
                Button("送出") {
                    viewModel.sendMsg()
                }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationBarStyle(title: "社區百問")
        .background(Color(UIColor.systemGroupedBackground))
        .onDisappear {
            viewModel.playerRelease()
        }
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            FacilityView()
        }
    }
}
