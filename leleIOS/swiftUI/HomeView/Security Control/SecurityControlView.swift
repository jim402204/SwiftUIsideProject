//
//  SecurityControlView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct SecurityControlView: View {
    @StateObject private var viewModel = SecurityControlViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                
                Spacer()
                    .frame(height: 8)
                
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.list, id: \.id) { item in
                        SecurityControlCell(viewModel: item)
                    }
                }
            }
        }
        .refreshable {
            viewModel.callAPI()
        }
        .navigationBarStyle(title: "即時影像")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        SecurityControlView()
    }
}
