//
//  VoteView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/18.
//

import SwiftUI

struct VoteView: View {
    @State var viewModel = VoteViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.list.enumerated()), id: \.offset) { _, item in
                        Text(item.title)
                    }
                }
            }
        }
        .navigationBarStyle(title: "線上投票")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        VoteView()
    }
}
