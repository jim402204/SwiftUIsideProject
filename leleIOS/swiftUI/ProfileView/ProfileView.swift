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
                    .applyShadow()
                
                if viewModel.isCommunityOpening {
                    // 社區資訊卡片
                    CommunityInfoCardView(viewModel: viewModel, cardCornerRadius: cardCornerRadius)
                } else {
                    Text("尚未加入社區")
                        .appFont(.title3, color: .gray)
                }
                
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
                            
                            Link(destination: URL(string: "https://www.apple.com")!) {
                                HStack {
                                    Text("隱私權政策")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: arrowIcon)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }
                        .background(Color.white)
                    }
                    .cornerRadius(cardCornerRadius)
                    .applyShadow()
                }

            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarStyle(title: "個人",isRootPage: true)
        .toolbar(content: {
            NavigationLink(destination: Text("ddd")) {
                Image(systemName: "info.circleX")
                    .foregroundStyle(.white)
            }
        })
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


