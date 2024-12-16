//
//  RuleView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct RuleView: View {
    @StateObject private var viewModel = RuleViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.list, id: \.id) { item in
                        NavigationLink(destination:
                            BulletinDetailView(viewModel: item)
                        ) {
                            BulletinCell(viewModel: item)
                        }
                    }
                    .background(Color.white)
                }
            }
        }
        .refreshable {
            viewModel.callAPI()
        }
        .navigationBarStyle(title: "規約辦法")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        RuleView()
    }
}
