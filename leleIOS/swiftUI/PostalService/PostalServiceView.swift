//
//  PostalServiceView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/5.
//

import SwiftUI

struct PostalServiceView: View {
    
    @StateObject private var viewModel = PostalServicViewModel()
    @State var fastViewModel = FastRegisterPackageViewModel()
    @State private var isCameraPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 分段控制器
            SegmentedTabView(
                tabs: viewModel.tabs,
                selectedTab: viewModel.selectedTab,
                onTabChanged: viewModel.tabChanged
            )
            
            PageTabView(
                tabs: viewModel.tabs,
                selectedTab: $viewModel.selectedTab,
                allList: viewModel.allList,
                onChange: viewModel.tabChanged,
                cellBuilder: { item in
                    PostalServiceCell(viewModel: item)
                }
            )
        }
        .navigationBarStyle(title: "包裹寄物")
        .background(Color(UIColor.systemGroupedBackground))
        .toolbar(content: {
            NavigationLink(destination: PostalServiceEntryView()) {
                Image(systemName: "mail.stack.fill")
                    .foregroundStyle(.white)
            }
            Button(action: {
                isCameraPresented = true
            }) {
                Image(systemName: "bolt.circle")
                    .foregroundStyle(.white)
            }
        })
        .onAppear {
            viewModel.callAPI()
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraView(
                isPresented: $isCameraPresented,
                capturedImageDate: $fastViewModel.imageData
            )
        }
        .onChange(of: fastViewModel.reflushList) {
            viewModel.callAPI()
        }
    }
}

#Preview {
    NavigationStack {
        PostalServiceView()
    }
}
