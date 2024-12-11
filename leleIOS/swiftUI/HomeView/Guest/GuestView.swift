//
//  GuestView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/11.
//

import SwiftUI

struct GuestView: View {
    @StateObject private var viewModel = GuestViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        GuestCell(viewModel: item)
                    }
                }
            }
        }
        .navigationBarStyle(title: "訪客紀錄")
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        GuestView()
    }
}
