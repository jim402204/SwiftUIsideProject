//
//  LoginRecordView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import SwiftUI

struct LoginRecordView: View {
    @State private var viewModel = LoginRecordViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        VStack(spacing: 1) {
                            Text(item.model)
                            Text(item.lastLogin)
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.callAPI()
        }
        .navigationBarStyle(title: "已登入的裝置")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear() {
            viewModel.callAPI()
        }
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            LoginRecordView()
        }
    }
}
