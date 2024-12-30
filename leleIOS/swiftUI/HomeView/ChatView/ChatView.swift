//
//  ChatView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/19.
//

import SwiftUI

struct ChatView: View {
    private let presetQuestions =
    ["我想填瓦斯度數", "最近社區有什麼活動？", "大型垃圾要怎麼處理？", "問題4", "問題5"]
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.list.enumerated()), id: \.offset) { index, item in
                            ChatBubble(message: item.msg, isMyMsg: item.isMyMsg)
                                .id(index) // 給每條訊息設置唯一標識符
                        }
                    }
                }
                .onTapGesture {
                    isTextFieldFocused = false
                }
                .onChange(of: viewModel.list.count) {
                    // 滾動到最新的訊息
                    if let lastIndex = viewModel.list.indices.last {
                        withAnimation {
                            proxy.scrollTo(lastIndex, anchor: .bottom)
                        }
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(presetQuestions, id: \.self) { question in
                        Button(action: {
                            viewModel.message = question
                        }) {
                            Text(question)
                                .fixedSize(horizontal: false, vertical: true) // 允许垂直方向展开
                                .frame(maxWidth: 120) // 保持宽度限制
                                .frame(height: 50) // 高度设定
                                .padding(.horizontal, 8)
                                .appFont(.subheadline)
                                .lineLimit(2) // 确保不限制行数
                                .multilineTextAlignment(.leading) // 多行对齐方式
                                .background(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .cornerRadius(10)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical,5)
            
            HStack(spacing: 0) {
                TextField("訊問樂樂管家！", text: $viewModel.message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)
                Button(action: {
                    viewModel.sendMsg()
                }) {
                    Image(systemName: "paperplane.fill") // 系统图标
                        .resizable()
                        .frame(width: 24, height: 24) // 调整图片大小
                        .foregroundStyle(.teal)
                }
                .padding(.trailing)
            }
            .padding(.vertical, 12)
            .background(Color(UIColor.systemGray5))
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationBarStyle(title: "社區百問")
        .background(Color(UIColor.systemGroupedBackground))
//        .loadingOverlay(isLoading: $viewModel.loadingManager.isLoading)
        .onDisappear {
            viewModel.player.stop()
        }
    }
}

#Preview {
    PreviewTokenView {
//        NavigationStack {
        ChatView()
//        }
    }
}
