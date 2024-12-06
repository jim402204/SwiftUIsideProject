//
//  ProfileView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/2.
//

import SwiftUI

let arrowIcon = "chevron.right"

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ProfileViewModel()

    let cardCornerRadius: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // 個人信息卡片
                UserInfoCardView(viewModel: viewModel)
                    .cornerRadius(cardCornerRadius)
                    .shadow(radius: 1)
                
                // 社區資訊卡片
                CommunityInfoCardView(viewModel: viewModel, cardCornerRadius: cardCornerRadius)
                
                
                VStack(spacing: 10) {
                    Text("產品資訊")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            
                            HStack {
                                Text("版本資訊： v1.0.0")
                                Spacer()
                            }
                            .padding()
                            
                            Divider()
                            
                            HStack {
                                Link(destination: URL(string: "https://www.apple.com")!) {
                                    Text("隱私權政策")
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: arrowIcon)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            
                        }
                        .background(Color.white)
                    }
                    .cornerRadius(cardCornerRadius)
                    .shadow(radius: 1)
                }
                
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarStyle(title: "個人")
        .navigationBarItems(trailing:
                                Button(action: {
            // 處理信息按鈕點擊
        }) {
            Image(systemName: "info.circleX")
                .foregroundColor(.primary)
        }
        )//navigationBarItems
        .onAppear {
            viewModel.setAppState(appState)
            viewModel.pointAPI()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AppState())
    }
}


