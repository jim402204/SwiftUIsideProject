//
//  BulletinView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/10.
//

import SwiftUI

struct BulletinView: View {
    @StateObject private var viewModel = BulletinViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.list, id: \.id) { item in
                        NavigationLink(destination: BulletinDetailView(viewModel: item)
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
        .navigationBarStyle(title: "社區公告")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    PreviewTokenView {
        NavigationStack {
            BulletinView()
        }
    }
}


