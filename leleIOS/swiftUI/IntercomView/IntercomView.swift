//
//  IntercomView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct IntercomView: View {
    @StateObject private var viewModel = IntercomViewModel()
    var isRootPage: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            SegmentedTabView(
                tabs: viewModel.tabs,
                selectedTab: viewModel.selectedTab,
                titleMapping: viewModel.titleMapping,
                onTabChanged: viewModel.tabChanged
            )
            
            PageTabView(
                tabs: viewModel.tabs,
                selectedTab: $viewModel.selectedTab,
                allList: viewModel.allList,
                onChange: viewModel.tabChanged,
                cellBuilder: { item in
                    IntercomCell(viewModel: item)
                }
            )
        }
        .navigationBarStyle(title: "智慧對講", isRootPage: isRootPage)
        .toolbar(content: {
            NavigationLink(destination: Text("ddd")) {
                Image(systemName: "gearshapeX")
                    .foregroundStyle(.white)
            }
        })
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        IntercomView()
    }
}


